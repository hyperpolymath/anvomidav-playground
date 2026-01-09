;; SPDX-License-Identifier: AGPL-3.0-or-later
;; ECOSYSTEM.scm - Ecosystem position for anvomidav-playground
;; Media-Type: application/vnd.ecosystem+scm

(ecosystem
  (version "1.0")
  (name "anvomidav-playground")
  (type "language-playground")
  (purpose "Formally verified real-time systems programming")

  (position-in-ecosystem
    (category "safety-critical-languages")
    (subcategory "real-time-verification")
    (parent "language-playgrounds")
    (grandparent "nextgen-languages")
    (unique-value
      ("WCET analysis experimentation"
       "Rate-Monotonic schedulability testing"
       "Formal verification playground")))

  (related-projects
    ((oblibeny-playground
       ((relationship . "sibling-standard")
        (description . "Security-critical embedded systems")))
     (phronesis-playground
       ((relationship . "sibling-standard")
        (description . "AI ethics and safety specifications")))
     (spark-ada
       ((relationship . "inspiration")
        (description . "Formal verification concepts")))
     (anvomidav
       ((relationship . "upstream")
        (description . "Main Anvomidav language repository")))))

  (what-this-is
    ("Real-time systems language exploration"
     "WCET analysis experimentation"
     "Formal verification playground"
     "Schedulability demo with deterministic output"))

  (what-this-is-not
    ("Production compiler"
     "General purpose language"
     "Soft real-time only"
     "Authoritative semantics source")))
