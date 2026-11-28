// Package itflow talks to the ITFlow API v1. The API key is only ever held
// by the server and sent in the X-API-Key header and the request body, never
// in the URL.
package itflow

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net"
	"net/http"
	"net/url"
	"regexp"
	"strings"
	"time"
)

// maxBody caps how much of a response is read.
const maxBody = 10 << 20

var (
	// ErrUnauthorized means the API key was rejected or has expired.
	ErrUnauthorized = errors.New("itflow: api key rejected")
	// ErrForbidden means the key lacks the permission for this module.
	ErrForbidden = errors.New("itflow: no permission for this endpoint")
	// ErrNotFound means the endpoint does not exist in this ITFlow version.
	ErrNotFound = errors.New("itflow: endpoint not found")
)

var segment = regexp.MustCompile(`^[a-z][a-z_]{0,40}$`)

// Client calls one ITFlow instance.
type Client struct {
	base *url.URL
	key  string
	http *http.Client
}

// New checks the base URL and returns a client. HTTPS is required except for
// a loopback host (local tests).
func New(baseURL, apiKey string, hc *http.Client) (*Client, error) {
	u, err := url.Parse(strings.TrimRight(strings.TrimSpace(baseURL), "/"))
	if err != nil || u.Host == "" {
		return nil, errors.New("itflow: invalid base url")
	}
	if u.User != nil || u.RawQuery != "" || u.Fragment != "" {
		return nil, errors.New("itflow: base url must not contain credentials, query or fragment")
	}
	switch {
	case u.Scheme == "https":
	case u.Scheme == "http" && isLoopback(u.Hostname()):
	default:
		return nil, errors.New("itflow: base url must use https")
	}
	if strings.TrimSpace(apiKey) == "" {
		return nil, errors.New("itflow: api key missing")
	}
	if hc == nil {
		hc = &http.Client{Timeout: 20 * time.Second}
	}
	return &Client{base: u, key: strings.TrimSpace(apiKey), http: hc}, nil
}

func isLoopback(host string) bool {
	if host == "localhost" {
		return true
	}
	ip := net.ParseIP(host)
	return ip != nil && ip.IsLoopback()
}

// Response is the JSON envelope ITFlow returns.
type Response struct {
	// Success is reported by ITFlow as the string "True" or "False".
	Success bool
	Message string
	Count   int
	Data    []map[string]any
	// Status is the HTTP status code.
	Status int
}

type rawResponse struct {
	Success any              `json:"success"`
	Message string           `json:"message"`
	Count   int              `json:"count"`
	Data    []map[string]any `json:"data"`
}

func (c *Client) endpoint(module, function string) (string, error) {
	if !segment.MatchString(module) || !segment.MatchString(function) {
		return "", fmt.Errorf("itflow: invalid endpoint %q/%q", module, function)
	}
	return c.base.JoinPath("api", "v1", module, function+".php").String(), nil
}

// Do sends a request without interpreting HTTP errors; Probe uses it to
// tell missing endpoints from existing ones.
func (c *Client) Do(ctx context.Context, method, module, function string, query url.Values) (*Response, error) {
	target, err := c.endpoint(module, function)
	if err != nil {
		return nil, err
	}
	if len(query) > 0 {
		target += "?" + query.Encode()
	}
	// The key goes in the header and in a JSON body. Some web servers in
	// front of ITFlow drop the header; ITFlow then reads the body, which,
	// unlike the URL, does not end up in access logs. ITFlow parses the body
	// for GET as well.
	payload, err := json.Marshal(map[string]string{"api_key": c.key})
	if err != nil {
		return nil, err
	}
	req, err := http.NewRequestWithContext(ctx, method, target, bytes.NewReader(payload))
	if err != nil {
		return nil, err
	}
	req.Header.Set("X-API-Key", c.key)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")
	res, err := c.http.Do(req)
	if err != nil {
		// The URL holds no secret, but keep errors short anyway.
		return nil, fmt.Errorf("itflow: request %s/%s failed: %w", module, function, unwrapURLError(err))
	}
	defer res.Body.Close()
	body, err := io.ReadAll(io.LimitReader(res.Body, maxBody))
	if err != nil {
		return nil, fmt.Errorf("itflow: reading %s/%s: %w", module, function, err)
	}
	out := &Response{Status: res.StatusCode}
	var raw rawResponse
	if len(strings.TrimSpace(string(body))) > 0 && json.Unmarshal(body, &raw) == nil {
		out.Success = isTrue(raw.Success)
		out.Message = raw.Message
		out.Count = raw.Count
		out.Data = raw.Data
	}
	return out, nil
}

func unwrapURLError(err error) error {
	var ue *url.Error
	if errors.As(err, &ue) {
		return ue.Err
	}
	return err
}

func isTrue(v any) bool {
	switch s := v.(type) {
	case bool:
		return s
	case string:
		return strings.EqualFold(s, "true")
	}
	return false
}

// Read calls <module>/read.php. An empty result is not an error: ITFlow
// answers "success: False" when nothing matches.
func (c *Client) Read(ctx context.Context, module string, query url.Values) (*Response, error) {
	res, err := c.Do(ctx, http.MethodGet, module, "read", query)
	if err != nil {
		return nil, err
	}
	if err := statusError(res.Status); err != nil {
		return nil, err
	}
	return res, nil
}

func statusError(status int) error {
	switch {
	case status == http.StatusUnauthorized:
		return ErrUnauthorized
	case status == http.StatusForbidden:
		return ErrForbidden
	case status == http.StatusNotFound:
		return ErrNotFound
	case status >= 400:
		return fmt.Errorf("itflow: unexpected status %d", status)
	}
	return nil
}
