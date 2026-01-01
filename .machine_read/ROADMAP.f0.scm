;; SPDX-License-Identifier: AGPL-3.0-or-later
;; ROADMAP.f0.scm - Feature 0 Roadmap (Foundation)

(define roadmap-f0
  '((schema . "hyperpolymath.roadmap/1")
    (feature . "f0")
    (title . "Foundation: Schedulability Demo with Deterministic Verdicts")
    (status . "in-progress")
    (updated . "2026-01-01")

    (goals
      . ("Establish playground infrastructure with Deno"
         "Implement basic schedulability analysis (Rate-Monotonic)"
         "Create deterministic demo with stable output"
         "Add snapshot tests for verdict output"))

    (deliverables
      . ((demo-module
           . ((file . "src/demo.ts")
              (description . "Offline timing/spec demo with deterministic output")
              (requirements
                . ("Output schedulability verdict for >=2 task sets"
                   "Fail deterministically for >=2 invalid specs"
                   "No network or real-time dependencies"))))

         (snapshot-tests
           . ((file . "test/demo_snapshot_test.ts")
              (description . "Snapshot tests verifying demo output stability")
              (requirements
                . ("Capture expected verdict output"
                   "Detect any output changes"))))

         (spec-document
           . ((file . ".machine_read/SPEC.playground.scm")
              (description . "Formal specification of timing surface and verdict format")))))

    (milestones
      . ((m0 . ((name . "Core Infrastructure")
                (items . ("ANCHOR.scm created"
                          ".machine_read/ directory established"
                          "deno task demo configured"
                          "just demo delegates properly"))))
         (m1 . ((name . "Demo Implementation")
                (items . ("src/demo.ts implemented"
                          "2+ valid task sets with verdicts"
                          "2+ invalid specs with failures"))))
         (m2 . ((name . "Testing")
                (items . ("Snapshot tests added"
                          "All tests pass deterministically"))))))

    (success-criteria
      . ("'deno task demo' runs offline with deterministic output"
         "'just demo' correctly delegates to deno task demo"
         "Demo outputs stable schedulability verdict for >=2 task sets"
         "At least 2 invalid-spec cases fail deterministically"
         "Snapshot tests capture and verify output"))

    (next-feature
      . ((name . "f1")
         (title . "Silver RSR: CI + Pinned Toolchain")
         (prerequisites . ("f0 complete" "verdict snapshots stable"))))))
