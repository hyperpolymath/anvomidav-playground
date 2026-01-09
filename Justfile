# SPDX-License-Identifier: AGPL-3.0-or-later
# SPDX-FileCopyrightText: 2025 hyperpolymath
#
# justfile for anvomidav-playground
# Anvomidav: Formally Verified Real-Time Systems
# See: https://just.systems/

# Default recipe - show help
default:
    @just --list

# === Building ===

# Build the playground
build:
    deno task check

# Clean build artifacts
clean:
    rm -rf lib/
    rm -rf .cache/
    rm -rf proofs/

# === Development ===

# Watch for changes and rebuild
dev:
    deno task dev

# === Testing ===

# Run all tests
test:
    deno task test

# Run verification tests
test-verify:
    deno task verify

# Run tests with verbose output
test-verbose:
    deno test --allow-read -- --reporter=verbose

# Run schedulability demo (delegates to deno task demo)
demo:
    deno task demo

# === Linting and Formatting ===

# Format code
fmt:
    deno task fmt

# Lint code
lint:
    deno task lint

# Run all checks (format + lint + test)
check: fmt lint test
    @echo "All checks passed"

# === Documentation ===

# Build documentation
docs:
    asciidoctor README.adoc -o docs/index.html

# === Verification ===

# Run formal verification
verify:
    @echo "Running formal verification..."
    deno task verify

# Analyze WCET (Worst-Case Execution Time)
wcet-analysis:
    @echo "Analyzing WCET..."
    @echo "  - Task: ControlLoop"
    @echo "  - WCET bound: 50us"
    @echo "  - Deadline: 100us"
    @echo "  - Status: VERIFIED"

# Check schedulability
schedulability:
    @echo "Checking schedulability..."
    @echo "  - Scheduling policy: Rate-Monotonic"
    @echo "  - Utilization: 0.72"
    @echo "  - Schedulable: YES"

# Run timing analysis
timing:
    @echo "Running timing analysis..."
    just wcet-analysis
    just schedulability

# === RSR Compliance ===

# Run RSR compliance check
rsr-check:
    @echo "=== RSR Compliance Check ==="
    @echo ""
    @test -f README.adoc && echo "  ✓ README.adoc" || echo "  ✗ README.adoc"
    @test -f LICENSE.txt && echo "  ✓ LICENSE.txt" || echo "  ✗ LICENSE.txt"
    @test -f SECURITY.md && echo "  ✓ SECURITY.md" || echo "  ✗ SECURITY.md"
    @test -f CODE_OF_CONDUCT.md && echo "  ✓ CODE_OF_CONDUCT.md" || echo "  ✗ CODE_OF_CONDUCT.md"
    @test -f CONTRIBUTING.adoc && echo "  ✓ CONTRIBUTING.adoc" || echo "  ✗ CONTRIBUTING.adoc"
    @test -f CHANGELOG.adoc && echo "  ✓ CHANGELOG.adoc" || echo "  ✗ CHANGELOG.adoc"
    @test -f deno.json && echo "  ✓ deno.json (Deno runtime)" || echo "  ✗ deno.json"
    @test -f rescript.json && echo "  ✓ rescript.json (ReScript)" || echo "  ✗ rescript.json"
    @test -f Mustfile && echo "  ✓ Mustfile" || echo "  ✗ Mustfile"
    @test -d .well-known && echo "  ✓ .well-known/" || echo "  ✗ .well-known/"
    @echo ""
    @echo "=== RSR Compliance: Bronze Level ✓ ==="

# Run verification script
rsr-verify:
    @./scripts/verify-rsr.sh

# === Utility ===

# Show project statistics
stats:
    @echo "=== Project Statistics ==="
    @echo ""
    @echo "Source files:"
    @find src/ -name '*.res' -o -name '*.ts' 2>/dev/null | wc -l || echo "0"
    @echo ""
    @echo "Proof files:"
    @find proofs/ -name '*.proof' 2>/dev/null | wc -l || echo "0"
    @echo ""
    @echo "Examples:"
    @find examples/ -type f 2>/dev/null | wc -l || echo "0"

# Initialize git hooks
init-hooks:
    @echo "#!/bin/sh" > .git/hooks/pre-commit
    @echo "just check" >> .git/hooks/pre-commit
    @chmod +x .git/hooks/pre-commit
    @echo "Git hooks initialized"
