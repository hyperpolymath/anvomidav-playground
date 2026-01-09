;; SPDX-License-Identifier: AGPL-3.0-or-later
;; PLAYBOOK.scm - Operational runbook

(define playbook
  `((version . "1.0.0")
    (project . "anvomidav-playground")
    (procedures
      ((build
         (("check" . "deno task check")
          ("test" . "deno task test")
          ("fmt" . "deno task fmt")))
       (verify
         (("wcet" . "deno task verify")
          ("demo" . "deno task demo")
          ("tests" . "deno task test")))
       (run
         (("demo" . "just demo")
          ("verify" . "just verify")))))
    (alerts
      ((test-failure . "Tests must pass before commit")
       (snapshot-mismatch . "Demo output changed - review before updating snapshot")
       (lint-error . "Code must pass linting before commit")))
    (contacts
      ((maintainer . "hyperpolymath")
       (upstream . "hyperpolymath/anvomidav")
       (issues . "github.com/hyperpolymath/anvomidav-playground/issues")))))
