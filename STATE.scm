;; SPDX-License-Identifier: AGPL-3.0-or-later
;; STATE.scm - Current project state

(state
  (version . "1.0.0")
  (phase . "framework")
  (updated . "2025-12-30T18:00:00Z")

  (project
    (name . "anvomidav-playground")
    (tier . "satellite")
    (license . "AGPL-3.0-or-later")
    (language . "rust"))

  (compliance
    (rsr . #t)
    (security-hardened . #t)
    (ci-cd . #f)
    (guix-primary . #f)
    (nix-fallback . #f))

  (current-position
    ((overall-completion . 10)
     (components
       ((specification . 30)
        (wcet-analyzer . 0)
        (proof-checker . 0)
        (scheduler . 0)
        (codegen . 0)))
     (working-features
       ("README documentation"
        "Language design concepts"))))

  (milestones
    (v0.1.0
      (status . "planned")
      (features
        "Basic parser"
        "WCET annotations"
        "Simple proof obligations"))))
