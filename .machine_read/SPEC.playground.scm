;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPEC.playground.scm - Playground Specification
;; Defines: timing spec surface, scenario format, verdict format

(define playground-spec
  '((schema . "hyperpolymath.spec/1")
    (domain . "anvomidav-playground")
    (version . "0.1.0")
    (updated . "2026-01-01")

    ;;; TIMING SPEC SURFACE
    ;; The timing specification surface defines the interface for real-time task analysis.
    (timing-spec-surface
      . ((units
           . ((time-base . "microseconds")
              (aliases . ((us . 1) (ms . 1000) (s . 1000000)))))

         (task-parameters
           . ((wcet . ((type . "number")
                       (unit . "microseconds")
                       (description . "Worst-Case Execution Time")
                       (constraint . "wcet > 0")))
              (deadline . ((type . "number")
                           (unit . "microseconds")
                           (description . "Relative deadline from task release")
                           (constraint . "deadline >= wcet")))
              (period . ((type . "number")
                         (unit . "microseconds")
                         (description . "Task inter-arrival time")
                         (constraint . "period >= deadline")))))

         (task-set-constraints
           . ((utilization-bound . "sum(wcet_i/period_i) <= 1.0")
              (rm-sufficient . "sum(wcet_i/period_i) <= n*(2^(1/n)-1)")
              (rm-necessary . "sum(wcet_i/period_i) <= 1.0")))))

    ;;; SCENARIO FORMAT
    ;; Scenarios define task sets for schedulability analysis.
    (scenario-format
      . ((structure
           . ((id . "unique scenario identifier")
              (name . "human-readable scenario name")
              (description . "optional description of the scenario")
              (tasks . "list of task specifications")
              (expected-verdict . "SCHEDULABLE | NOT_SCHEDULABLE | INVALID")))

         (task-structure
           . ((name . "task identifier")
              (wcet . "number in microseconds")
              (deadline . "number in microseconds")
              (period . "number in microseconds")))

         (example-valid
           . ((id . "control-system-1")
              (name . "Basic Control System")
              (tasks . (((name . "sensor") (wcet . 1000) (deadline . 5000) (period . 10000))
                        ((name . "compute") (wcet . 10000) (deadline . 40000) (period . 50000))
                        ((name . "actuate") (wcet . 5000) (deadline . 80000) (period . 100000))))
              (expected-verdict . "SCHEDULABLE")))

         (example-invalid
           . ((id . "invalid-wcet-exceeds-deadline")
              (name . "WCET Exceeds Deadline")
              (tasks . (((name . "bad-task") (wcet . 10000) (deadline . 5000) (period . 20000))))
              (expected-verdict . "INVALID")))))

    ;;; VERDICT FORMAT
    ;; Verdicts are the output of schedulability analysis.
    (verdict-format
      . ((structure
           . ((scenario-id . "identifier of analyzed scenario")
              (verdict . "SCHEDULABLE | NOT_SCHEDULABLE | INVALID")
              (details . "optional analysis details")
              (timestamp . "deterministic epoch (always 0 for reproducibility)")))

         (verdict-values
           . ((SCHEDULABLE . "Task set is schedulable under Rate-Monotonic")
              (NOT_SCHEDULABLE . "Task set exceeds RM bound; may miss deadlines")
              (INVALID . "Task set violates timing constraints (e.g., wcet > deadline)")))

         (output-format
           . ((type . "structured text")
              (stability . "deterministic - same input always produces same output")
              (example . "
---
SCENARIO: control-system-1 (Basic Control System)
VERDICT: SCHEDULABLE
DETAILS:
  - Total utilization: 35.00%
  - RM bound (3 tasks): 77.98%
  - Margin: 42.98%
---
")))

         (error-output
           . ((type . "structured text")
              (example . "
---
SCENARIO: invalid-wcet-exceeds-deadline (WCET Exceeds Deadline)
VERDICT: INVALID
ERROR: Task 'bad-task' violates constraint: wcet(10000us) > deadline(5000us)
---
")))))

    ;;; DEMO REQUIREMENTS
    (demo-requirements
      . ((minimum-valid-scenarios . 2)
         (minimum-invalid-scenarios . 2)
         (output-determinism . "required")
         (network-dependency . "forbidden")
         (real-time-dependency . "forbidden")))

    ;;; SNAPSHOT TEST CONTRACT
    (snapshot-contract
      . ((location . "test/demo_snapshot_test.ts")
         (purpose . "Verify demo output stability across runs")
         (behavior . "Compare actual demo output against stored snapshot")
         (update-policy . "Manual review required for any snapshot changes")))))
