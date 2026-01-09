;; SPDX-License-Identifier: AGPL-3.0-or-later
;; META.scm - Meta-level information for anvomidav-playground
;; Media-Type: application/meta+scheme

(meta
  (architecture-decisions
    ((adr-001
       ((status . "accepted")
        (date . "2025-12-30")
        (title . "Formal Verification for Real-Time Systems")
        (context . "Need formal verification for real-time systems")
        (decision . "Integrate WCET analysis and formal proofs into language")
        (consequences . "Compile-time guarantees for timing and correctness")))
     (adr-002
       ((status . "accepted")
        (date . "2025-12-30")
        (title . "Hyperpolymath Language Policy")
        (context . "Consistent language stack across all repositories")
        (decision . "Use Deno for tooling, JavaScript for implementation")
        (consequences . ("No npm dependencies"
                         "Deterministic builds"
                         "Type safety where needed"))))))

  (development-practices
    (code-style "deno-standard")
    (security
      (principle "Defense in depth")
      (hardening "openssf-scorecard"))
    (testing
      (approach "property-based")
      (coverage "snapshot-tests for deterministic output")
      (framework "deno test"))
    (versioning "SemVer")
    (documentation "AsciiDoc")
    (branching "trunk-based"))

  (design-rationale
    ((why-deno . "Modern runtime with built-in TypeScript, no npm dependency hell")
     (why-wcet . "Hard real-time guarantees required for safety-critical systems")
     (why-formal . "Safety-critical systems need mathematical proofs")
     (why-deterministic . "Reproducible builds and test output for verification"))))
