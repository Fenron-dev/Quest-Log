// Command itflow-probe checks which ITFlow API endpoints are reachable with
// a given key. It only sends GET requests, changes nothing and prints field
// names but never record contents.
//
// Usage:
//
//	ITFLOW_URL=https://itflow.example.com ITFLOW_API_KEY=... go run ./cmd/itflow-probe
package main

import (
	"context"
	"fmt"
	"io"
	"os"
	"os/signal"
	"strings"
	"time"

	"github.com/Fenron-dev/Quest-Log/server/internal/itflow"
)

func main() {
	os.Exit(run(os.Getenv, os.Stdout))
}

func run(getenv func(string) string, out io.Writer) int {
	base, key := getenv("ITFLOW_URL"), getenv("ITFLOW_API_KEY")
	if base == "" || key == "" {
		fmt.Fprintln(out, "Bitte ITFLOW_URL und ITFLOW_API_KEY als Umgebungsvariablen setzen.")
		return 2
	}
	c, err := itflow.New(base, key, nil)
	if err != nil {
		fmt.Fprintln(out, err)
		return 2
	}
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt)
	defer stop()
	ctx, cancel := context.WithTimeout(ctx, 2*time.Minute)
	defer cancel()

	checks := itflow.Probe(ctx, c)
	code := 0
	for _, ch := range checks {
		kind := "lesen"
		if ch.Write {
			kind = "schreiben"
		}
		line := fmt.Sprintf("%-26s %-10s %s", ch.Endpoint, kind, ch.Outcome)
		if ch.Detail != "" {
			line += " (" + ch.Detail + ")"
		}
		fmt.Fprintln(out, line)
		if len(ch.Fields) > 0 {
			fmt.Fprintln(out, "    Felder: "+strings.Join(ch.Fields, ", "))
		}
		if ch.Outcome == itflow.Unauthorized || ch.Outcome == itflow.Failed {
			code = 1
		}
	}
	return code
}
