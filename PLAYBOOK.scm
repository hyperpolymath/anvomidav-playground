;; SPDX-License-Identifier: AGPL-3.0-or-later
;; PLAYBOOK.scm - Operational runbook

(define playbook
  `((version . "1.0.0")
    (project . "anvomidav-playground")
    (procedures
      ((build
         (("setup" . "cargo build")
          ("test" . "cargo test")
          ("check" . "cargo check")))
       (verify
         (("wcet" . "cargo run -- --wcet-analysis src/main.anv")
          ("proofs" . "cargo run -- --verify src/main.anv")))
       (run
         (("example" . "cargo run -- examples/control_loop.anv")))))
    (alerts ())
    (contacts ())))
