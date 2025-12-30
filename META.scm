;; SPDX-License-Identifier: AGPL-3.0-or-later
;; META.scm - Project metadata and architecture decisions

(define project-meta
  `((version . "1.0.0")
    (name . "anvomidav-playground")
    (architecture-decisions
      ((adr-001
         ((status . "accepted")
          (date . "2025-12-30")
          (context . "Need formal verification for real-time systems")
          (decision . "Integrate WCET analysis and formal proofs into language")
          (consequences . "Compile-time guarantees for timing and correctness")))))
    (development-practices
      ((code-style . "rust-standard")
       (security . "openssf-scorecard")
       (testing . "property-based")
       (versioning . "semver")
       (documentation . "asciidoc")
       (branching . "trunk-based")))
    (design-rationale
      ((why-rust . "Memory safety and performance for compiler")
       (why-wcet . "Hard real-time guarantees required")
       (why-formal . "Safety-critical systems need proofs")))))
