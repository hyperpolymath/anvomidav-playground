// SPDX-License-Identifier: AGPL-3.0-or-later
// SPDX-FileCopyrightText: 2026 hyperpolymath
//
// Snapshot tests for demo verdict output
// Per SPEC.playground.scm snapshot-contract:
// - Verify demo output stability across runs
// - Compare actual demo output against stored snapshot

import { assertEquals } from '@std/assert';
import { analyzeScenario, formatVerdict, runDemo, scenarios } from '../src/demo.ts';
import type { Scenario, Verdict } from '../src/demo.ts';

// Expected full demo output snapshot
const EXPECTED_DEMO_OUTPUT = `================================================================================
ANVOMIDAV PLAYGROUND - SCHEDULABILITY DEMO
================================================================================

Analyzing task sets for Rate-Monotonic schedulability...

---
SCENARIO: control-system-1 (Basic Control System)
VERDICT: SCHEDULABLE
DETAILS:
  - Total utilization: 35.00%
  - RM bound (3 tasks): 77.98%
  - Margin: 42.98%
---

---
SCENARIO: monitoring-system (High-Frequency Monitoring)
VERDICT: SCHEDULABLE
DETAILS:
  - Total utilization: 55.00%
  - RM bound (3 tasks): 77.98%
  - Margin: 22.98%
---

---
SCENARIO: overloaded-system (Overloaded System)
VERDICT: NOT_SCHEDULABLE
DETAILS:
  - Total utilization: 105.00%
  - RM bound (3 tasks): 77.98%
  - Margin: -27.02%
---

---
SCENARIO: invalid-wcet-exceeds-deadline (WCET Exceeds Deadline)
VERDICT: INVALID
ERROR: Task 'bad-task' violates constraint: wcet(10000us) > deadline(5000us)
---

---
SCENARIO: invalid-deadline-exceeds-period (Deadline Exceeds Period)
VERDICT: INVALID
ERROR: Task 'bad-deadline' violates constraint: deadline(30000us) > period(20000us)
---

================================================================================
SUMMARY
================================================================================
Total scenarios analyzed: 5
  - Valid specifications: 3
    - SCHEDULABLE: 2
    - NOT_SCHEDULABLE: 1
  - Invalid specifications: 2
================================================================================`;

Deno.test('demo output matches snapshot', () => {
  const actual = runDemo();
  assertEquals(actual, EXPECTED_DEMO_OUTPUT);
});

Deno.test('scenario count meets requirements', () => {
  // Per golden-path: >=2 valid task sets, >=2 invalid specs
  let validCount = 0;
  let invalidCount = 0;

  for (const scenario of scenarios) {
    const verdict = analyzeScenario(scenario);
    if (verdict.verdict === 'INVALID') {
      invalidCount++;
    } else {
      validCount++;
    }
  }

  // At least 2 valid task sets with verdicts
  assertEquals(validCount >= 2, true, `Expected >=2 valid scenarios, got ${validCount}`);
  // At least 2 invalid-spec cases
  assertEquals(invalidCount >= 2, true, `Expected >=2 invalid scenarios, got ${invalidCount}`);
});

Deno.test('individual verdict snapshots', async (t) => {
  // Test each scenario produces expected verdict type

  await t.step('control-system-1 is SCHEDULABLE', () => {
    const scenario = scenarios.find((s) => s.id === 'control-system-1')!;
    const verdict = analyzeScenario(scenario);
    assertEquals(verdict.verdict, 'SCHEDULABLE');
    assertEquals(verdict.details.length, 3);
  });

  await t.step('monitoring-system is SCHEDULABLE', () => {
    const scenario = scenarios.find((s) => s.id === 'monitoring-system')!;
    const verdict = analyzeScenario(scenario);
    assertEquals(verdict.verdict, 'SCHEDULABLE');
  });

  await t.step('overloaded-system is NOT_SCHEDULABLE', () => {
    const scenario = scenarios.find((s) => s.id === 'overloaded-system')!;
    const verdict = analyzeScenario(scenario);
    assertEquals(verdict.verdict, 'NOT_SCHEDULABLE');
  });

  await t.step('invalid-wcet-exceeds-deadline is INVALID', () => {
    const scenario = scenarios.find((s) => s.id === 'invalid-wcet-exceeds-deadline')!;
    const verdict = analyzeScenario(scenario);
    assertEquals(verdict.verdict, 'INVALID');
    assertEquals(verdict.error?.includes('wcet'), true);
  });

  await t.step('invalid-deadline-exceeds-period is INVALID', () => {
    const scenario = scenarios.find((s) => s.id === 'invalid-deadline-exceeds-period')!;
    const verdict = analyzeScenario(scenario);
    assertEquals(verdict.verdict, 'INVALID');
    assertEquals(verdict.error?.includes('deadline'), true);
  });
});

Deno.test('verdict format is deterministic', () => {
  // Run multiple times and verify output is identical
  const output1 = runDemo();
  const output2 = runDemo();
  const output3 = runDemo();

  assertEquals(output1, output2);
  assertEquals(output2, output3);
});

Deno.test('verdict format structure', () => {
  const scenario: Scenario = {
    id: 'test-scenario',
    name: 'Test Scenario',
    tasks: [{ name: 'task1', wcet: 1000, deadline: 5000, period: 10000 }],
  };

  const verdict = analyzeScenario(scenario);
  const formatted = formatVerdict(verdict);

  // Verify structure per SPEC.playground.scm
  assertEquals(formatted.startsWith('---'), true);
  assertEquals(formatted.endsWith('---'), true);
  assertEquals(formatted.includes('SCENARIO:'), true);
  assertEquals(formatted.includes('VERDICT:'), true);
});
