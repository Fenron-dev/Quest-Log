package itflow

import (
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

const testKey = "test-key-not-real"

// fakeITFlow mimics the ITFlow API v1 for a handful of endpoints.
func fakeITFlow(t *testing.T) *httptest.Server {
	t.Helper()
	return httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Query().Has("api_key") {
			t.Errorf("api key must not be sent in the URL")
		}
		if r.Header.Get("X-API-Key") != testKey {
			w.WriteHeader(http.StatusUnauthorized)
			_ = json.NewEncoder(w).Encode(map[string]any{"success": "False", "message": "Authentication failed."})
			return
		}
		switch r.URL.Path {
		case "/itflow/api/v1/clients/read.php":
			_ = json.NewEncoder(w).Encode(map[string]any{
				"success": "True", "count": 1,
				"data": []map[string]any{{"client_id": "1", "client_name": "Beispiel GmbH"}},
			})
		case "/itflow/api/v1/tickets/read.php":
			_ = json.NewEncoder(w).Encode(map[string]any{"success": "False", "message": "No resource"})
		case "/itflow/api/v1/projects/read.php":
			w.WriteHeader(http.StatusForbidden)
		case "/itflow/api/v1/ticket_replies/create.php", "/itflow/api/v1/tickets/create.php":
			if r.Method != http.MethodPost {
				w.WriteHeader(http.StatusMethodNotAllowed)
				return
			}
			t.Errorf("probe must not POST")
		default:
			http.NotFound(w, r)
		}
	}))
}

func TestNewRequiresHTTPS(t *testing.T) {
	cases := map[string]bool{
		"https://itflow.example.com":         true,
		"https://itflow.example.com/sub/":    true,
		"http://localhost:8080":              true,
		"http://127.0.0.1":                   true,
		"http://itflow.example.com":          false,
		"ftp://itflow.example.com":           false,
		"https://user:pw@itflow.example.com": false,
		"https://itflow.example.com/?a=1":    false,
		"not a url":                          false,
		"":                                   false,
	}
	for in, ok := range cases {
		_, err := New(in, testKey, nil)
		if (err == nil) != ok {
			t.Errorf("New(%q) error = %v, want ok=%v", in, err, ok)
		}
	}
	if _, err := New("https://itflow.example.com", " ", nil); err == nil {
		t.Error("empty key must be rejected")
	}
}

func TestReadSendsKeyInHeaderAndParses(t *testing.T) {
	srv := fakeITFlow(t)
	defer srv.Close()
	c, err := New(srv.URL+"/itflow/", testKey, srv.Client())
	if err != nil {
		t.Fatal(err)
	}
	res, err := c.Read(context.Background(), "clients", nil)
	if err != nil {
		t.Fatal(err)
	}
	if !res.Success || res.Count != 1 || res.Data[0]["client_name"] != "Beispiel GmbH" {
		t.Fatalf("unexpected response %+v", res)
	}
	empty, err := c.Read(context.Background(), "tickets", nil)
	if err != nil || empty.Success || len(empty.Data) != 0 {
		t.Fatalf("empty read: %+v, %v", empty, err)
	}
	if _, err := c.Read(context.Background(), "projects", nil); !errors.Is(err, ErrForbidden) {
		t.Fatalf("want ErrForbidden, got %v", err)
	}
	if _, err := c.Read(context.Background(), "invoices", nil); !errors.Is(err, ErrNotFound) {
		t.Fatalf("want ErrNotFound, got %v", err)
	}
}

func TestReadRejectsBadKey(t *testing.T) {
	srv := fakeITFlow(t)
	defer srv.Close()
	c, _ := New(srv.URL+"/itflow", "wrong", srv.Client())
	if _, err := c.Read(context.Background(), "clients", nil); !errors.Is(err, ErrUnauthorized) {
		t.Fatalf("want ErrUnauthorized, got %v", err)
	}
}

func TestEndpointRejectsTraversal(t *testing.T) {
	c, _ := New("https://itflow.example.com", testKey, nil)
	for _, m := range []string{"../config", "clients/../x", "Clients", "", "a b"} {
		if _, err := c.endpoint(m, "read"); err == nil {
			t.Errorf("module %q must be rejected", m)
		}
	}
}

func TestProbeReportsFieldsNotValues(t *testing.T) {
	srv := fakeITFlow(t)
	defer srv.Close()
	c, _ := New(srv.URL+"/itflow", testKey, srv.Client())
	checks := Probe(context.Background(), c)
	got := map[string]Check{}
	for _, ch := range checks {
		got[ch.Endpoint] = ch
		for _, f := range ch.Fields {
			if strings.Contains(f, "Beispiel") {
				t.Fatalf("probe leaked a value: %v", ch.Fields)
			}
		}
	}
	if len(checks) != len(probeTargets) {
		t.Fatalf("want %d checks, got %d", len(probeTargets), len(checks))
	}
	want := map[string]Outcome{
		"clients/read":          Available,
		"tickets/read":          Available,
		"projects/read":         Forbidden,
		"assets/read":           Missing,
		"ticket_replies/create": Available,
		"tickets/create":        Available,
		"tasks/complete":        Missing,
	}
	for ep, o := range want {
		if got[ep].Outcome != o {
			t.Errorf("%s: outcome %q, want %q", ep, got[ep].Outcome, o)
		}
	}
	if f := got["clients/read"].Fields; len(f) != 2 || f[0] != "client_id" || f[1] != "client_name" {
		t.Errorf("clients fields = %v", f)
	}
}

func TestProbeStopsOnRejectedKey(t *testing.T) {
	srv := fakeITFlow(t)
	defer srv.Close()
	c, _ := New(srv.URL+"/itflow", "wrong", srv.Client())
	checks := Probe(context.Background(), c)
	if len(checks) != 1 || checks[0].Outcome != Unauthorized {
		t.Fatalf("want a single Unauthorized check, got %+v", checks)
	}
}
