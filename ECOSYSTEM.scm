;; SPDX-License-Identifier: AGPL-3.0-or-later
;; ECOSYSTEM.scm - Ecosystem positioning

(ecosystem
  (version . "1.0.0")
  (name . "anvomidav-playground")
  (type . "language-playground")
  (purpose . "Formally verified real-time systems programming")

  (position-in-ecosystem
    ((parent . "language-playgrounds")
     (grandparent . "nextgen-languages")
     (category . "safety-critical-languages")))

  (related-projects
    ((oblibeny-playground
       ((relationship . "sibling-standard")
        (description . "Security-critical embedded systems")))
     (phronesis-playground
       ((relationship . "sibling-standard")
        (description . "AI ethics and safety specifications")))
     (spark-ada
       ((relationship . "inspiration")
        (description . "Formal verification concepts")))))

  (what-this-is
    ("Real-time systems language exploration"
     "WCET analysis experimentation"
     "Formal verification playground"))

  (what-this-is-not
    ("Production compiler"
     "General purpose language"
     "Soft real-time only")))
