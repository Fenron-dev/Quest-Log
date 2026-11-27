package itflow

import (
	"context"
	"errors"
	"net/http"
	"net/url"
	"sort"
)

// Outcome of probing one endpoint.
type Outcome string

const (
	Available    Outcome = "verfügbar"
	Missing      Outcome = "fehlt"
	Forbidden    Outcome = "keine Berechtigung"
	Unauthorized Outcome = "Schlüssel abgelehnt"
	Failed       Outcome = "Fehler"
)

// Check is the result for one endpoint. It never contains record values,
// only field names, so the output can be shared without customer data.
type Check struct {
	Endpoint string
	Write    bool
	Outcome  Outcome
	Fields   []string
	Detail   string
}

type probeTarget struct {
	module, function string
	write            bool
}

// Endpoints Quest-Log needs. Write endpoints are only called with GET,
// which ITFlow refuses with 405 before doing anything; that proves they
// exist without changing data.
var probeTargets = []probeTarget{
	{"clients", "read", false},
	{"contacts", "read", false},
	{"assets", "read", false},
	{"projects", "read", false},
	{"tickets", "read", false},
	{"ticket_replies", "read", false},
	{"tasks", "read", false},
	{"recurring_tickets", "read", false},
	{"technicians", "read", false},
	{"technicians", "time", false},
	{"tickets", "create", true},
	{"tickets", "update", true},
	{"tickets", "resolve", true},
	{"ticket_replies", "create", true},
	{"tasks", "complete", true},
	{"recurring_tickets", "create", true},
}

// Probe checks which endpoints exist and are allowed for the key. It only
// sends GET requests and reads at most one record per endpoint.
func Probe(ctx context.Context, c *Client) []Check {
	checks := make([]Check, 0, len(probeTargets))
	for _, t := range probeTargets {
		check := Check{Endpoint: t.module + "/" + t.function, Write: t.write}
		res, err := c.Do(ctx, http.MethodGet, t.module, t.function, url.Values{"limit": {"1"}})
		switch {
		case err != nil:
			check.Outcome, check.Detail = Failed, err.Error()
		case res.Status == http.StatusUnauthorized:
			check.Outcome = Unauthorized
		case res.Status == http.StatusForbidden:
			check.Outcome = Forbidden
		case res.Status == http.StatusNotFound:
			check.Outcome = Missing
		case res.Status == http.StatusMethodNotAllowed:
			// Exists, but takes the other method (POST for writes).
			check.Outcome = Available
		case res.Status >= 400:
			check.Outcome, check.Detail = Failed, http.StatusText(res.Status)
		default:
			check.Outcome = Available
			check.Fields = fieldNames(res.Data)
			if !res.Success && res.Message != "" {
				check.Detail = "keine Datensätze oder Parameter nötig"
			}
		}
		checks = append(checks, check)
		if check.Outcome == Unauthorized {
			// Every further call would fail the same way.
			break
		}
		if errors.Is(ctx.Err(), context.Canceled) {
			break
		}
	}
	return checks
}

func fieldNames(rows []map[string]any) []string {
	if len(rows) == 0 {
		return nil
	}
	names := make([]string, 0, len(rows[0]))
	for k := range rows[0] {
		names = append(names, k)
	}
	sort.Strings(names)
	return names
}
