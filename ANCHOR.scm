;; SPDX-License-Identifier: AGPL-3.0-or-later
;; ANCHOR.scm - Project anchor configuration
;; Schema: hyperpolymath.anchor/1

(define anchor
  '((schema . "hyperpolymath.anchor/1")
    (repo . "hyperpolymath/anvomidav-playground")
    (date . "2026-01-01")
    (authority . "repo-superintendent")
    (purpose
      . ("Scope arrest: real-time + formal methods playground; keep it testable."
         "Prefer ReScript+Deno for tooling; keep semantics downstream from upstream Anvomidav."
         "One offline timing/spec demo with deterministic output."))

    (identity
      . ((project . "Anvomidav Playground")
         (kind . "playground")
         (one-sentence . "Playground for Anvomidav: formally-verified real-time systems language.")
         (upstream . "hyperpolymath/anvomidav")))

    (semantic-anchor
      . ((policy . "downstream")
         (upstream-authority
           . ("Anvomidav semantics/spec live upstream."
              "This repo: schedulability examples, contracts, small analyzers."))))

    (implementation-policy
      . ((allowed . ("ReScript" "Deno" "Scheme" "Shell" "Just" "Markdown" "AsciiDoc"))
         (quarantined . ("Any full compiler/typechecker (belongs upstream)"))
         (forbidden
           . ("Second authoritative semantics"
              "Network-required execution"
              "Unpinned time-dependent tests"))))

    (golden-path
      . ((smoke-test-command
           . ("deno task test"
              "deno task demo"
              "just demo  ;; must delegate to deno task demo"))
         (success-criteria
           . ("Demo outputs a stable schedulability/latency verdict for >=2 task sets."
              "At least 2 invalid-spec cases fail deterministically."))))

    (mandatory-files
      . ("./.machine_read/LLM_SUPERINTENDENT.scm"
         "./.machine_read/ROADMAP.f0.scm"
         "./.machine_read/SPEC.playground.scm"))

    (first-pass-directives
      . ("SPEC.playground.scm must define: timing spec surface used in demos, scenario format, verdict format."
         "Add snapshot tests for verdict output."))

    (rsr . ((target-tier . "bronze-now")
            (upgrade-path . "silver-after-f1 (verdict snapshots + CI + pinned toolchain)")))))
