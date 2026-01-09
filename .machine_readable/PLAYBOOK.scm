;; SPDX-License-Identifier: AGPL-3.0-or-later
;; PLAYBOOK.scm - Operational runbook for anvomidav-playground

(define playbook
  `((version . "1.0.0")
    (project . "anvomidav-playground")
    (procedures
      ((deploy . (("build" . "just build")
                  ("test" . "just test")
                  ("demo" . "just demo")
                  ("release" . "just release")))
       (verify . (("wcet" . "deno task verify")
                  ("tests" . "deno task test")
                  ("lint" . "deno task lint")))
       (rollback . (("git-reset" . "git reset --hard HEAD~1")
                    ("restore-snapshot" . "git checkout -- .")))
       (debug . (("run-verbose" . "deno test --allow-read -- --reporter=verbose")
                 ("check-types" . "deno task check")
                 ("inspect-output" . "deno task demo | head -50")))))
    (alerts
      ((test-failure . "Tests must pass before commit")
       (snapshot-mismatch . "Demo output changed - review before updating snapshot")))
    (contacts
      ((maintainer . "hyperpolymath")
       (upstream . "hyperpolymath/anvomidav")))))
