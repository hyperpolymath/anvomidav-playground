;; SPDX-License-Identifier: AGPL-3.0-or-later
;; LLM_SUPERINTENDENT.scm - Guidance for AI agents working with this repository

(define llm-superintendent
  '((schema . "hyperpolymath.superintendent/1")
    (repo . "hyperpolymath/anvomidav-playground")
    (updated . "2026-01-01")

    (role
      . "This file provides guidance for LLM agents (Claude, GPT, etc.) working with the Anvomidav Playground repository.")

    (project-context
      . ((kind . "playground")
         (purpose . "Schedulability examples, contracts, and small analyzers for Anvomidav")
         (upstream . "hyperpolymath/anvomidav")
         (relationship . "downstream - semantics/spec live upstream")))

    (do
      . ("Use ReScript or Deno for new tooling"
         "Keep all timing tests deterministic (no real clocks)"
         "Document WCET/deadline/period units explicitly"
         "Run 'deno task test' and 'deno task demo' before committing"
         "Follow existing code patterns in src/main.js"
         "Use formal verification terminology consistently"))

    (do-not
      . ("Implement compiler or typechecker logic (belongs upstream)"
         "Add network-dependent functionality"
         "Create a second authoritative semantics"
         "Add time-dependent tests without pinned/mocked time"
         "Modify semantics that conflict with upstream Anvomidav"))

    (key-files
      . ((anchor . "ANCHOR.scm")
         (spec . ".machine_read/SPEC.playground.scm")
         (roadmap . ".machine_read/ROADMAP.f0.scm")
         (main-entry . "src/main.js")
         (demo-entry . "src/demo.ts")
         (example . "examples/01_control_loop.anv")))

    (smoke-tests
      . ("deno task test"
         "deno task demo"
         "just demo"))

    (terminology
      . ((wcet . "Worst-Case Execution Time")
         (deadline . "Maximum time allowed for task completion")
         (period . "Time between successive task releases")
         (utilization . "WCET / Period ratio")
         (rm-bound . "Rate-Monotonic schedulability bound: n*(2^(1/n)-1)")))

    (output-contracts
      . ("Demo must produce stable, deterministic output"
         "Verdicts: SCHEDULABLE or NOT_SCHEDULABLE"
         "At least 2 task sets must be verified"
         "At least 2 invalid specs must fail deterministically"))))
