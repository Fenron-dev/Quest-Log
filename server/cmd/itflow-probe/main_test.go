package main

import (
	"strings"
	"testing"
)

func TestRunNeedsConfiguration(t *testing.T) {
	var out strings.Builder
	code := run(func(string) string { return "" }, &out)
	if code != 2 || !strings.Contains(out.String(), "ITFLOW_URL") {
		t.Fatalf("code %d, output %q", code, out.String())
	}
}

func TestRunRejectsPlainHTTP(t *testing.T) {
	env := map[string]string{"ITFLOW_URL": "http://itflow.example.com", "ITFLOW_API_KEY": "x"}
	var out strings.Builder
	if code := run(func(k string) string { return env[k] }, &out); code != 2 {
		t.Fatalf("code %d, output %q", code, out.String())
	}
}
