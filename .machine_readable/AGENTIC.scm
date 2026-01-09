;; SPDX-License-Identifier: AGPL-3.0-or-later
;; AGENTIC.scm - AI agent interaction patterns for anvomidav-playground

(define agentic-config
  `((version . "1.0.0")
    (project . "anvomidav-playground")
    (claude-code
      ((model . "claude-opus-4-5-20251101")
       (tools . ("read" "edit" "bash" "grep" "glob"))
       (permissions . "read-all")))
    (patterns
      ((code-review . "thorough")
       (refactoring . "conservative")
       (testing . "comprehensive")
       (verification . "formal")))
    (constraints
      ((languages . ("javascript" "scheme"))
       (banned . ("typescript" "go" "python" "makefile"))))
    (project-specific
      ((timing-analysis . "enforce-wcet-bounds")
       (proofs . "check-all-obligations")
       (determinism . "required-for-snapshots")))))
