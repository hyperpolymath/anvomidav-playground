// SPDX-License-Identifier: AGPL-3.0-or-later
// SPDX-FileCopyrightText: 2025 hyperpolymath
//
// Tests for Anvomidav Verification

import { assertEquals, assertExists } from '@std/assert';
import {
  timingSpec,
  verifyWcetDeadline,
  verifyDeadlinePeriod,
  taskUtilization,
  createVerifiedTask,
} from '../src/main.ts';
import {
  proofObligation,
  verifyObligation,
} from '../src/verify.ts';

Deno.test('timingSpec - creates valid timing specification', () => {
  const spec = timingSpec(1000, 5000, 10000);
  assertEquals(spec.wcet, 1000);
  assertEquals(spec.deadline, 5000);
  assertEquals(spec.period, 10000);
});

Deno.test('verifyWcetDeadline - passes when WCET <= deadline', () => {
  const spec = timingSpec(1000, 5000, 10000);
  assertEquals(verifyWcetDeadline(spec), true);
});

Deno.test('verifyWcetDeadline - fails when WCET > deadline', () => {
  const spec = timingSpec(6000, 5000, 10000);
  assertEquals(verifyWcetDeadline(spec), false);
});

Deno.test('verifyDeadlinePeriod - passes when deadline <= period', () => {
  const spec = timingSpec(1000, 5000, 10000);
  assertEquals(verifyDeadlinePeriod(spec), true);
});

Deno.test('verifyDeadlinePeriod - fails when deadline > period', () => {
  const spec = timingSpec(1000, 15000, 10000);
  assertEquals(verifyDeadlinePeriod(spec), false);
});

Deno.test('taskUtilization - calculates correctly', () => {
  const spec = timingSpec(1000, 5000, 10000);
  assertEquals(taskUtilization(spec), 0.1); // 1000/10000 = 0.1
});

Deno.test('createVerifiedTask - creates verified task when constraints met', () => {
  const task = createVerifiedTask('TestTask', 1000, 5000, 10000);
  assertEquals(task.name, 'TestTask');
  assertEquals(task.verified, true);
  assertEquals(task.proofStatus, 'proven');
});

Deno.test('createVerifiedTask - creates failed task when constraints not met', () => {
  const task = createVerifiedTask('BadTask', 6000, 5000, 10000);
  assertEquals(task.verified, false);
  assertEquals(task.proofStatus, 'failed');
});

Deno.test('proofObligation - creates valid obligation', () => {
  const obligation = proofObligation(
    'TestObligation',
    'pre: x > 0',
    'post: result > 0',
    ['inv: x >= 0']
  );
  assertEquals(obligation.name, 'TestObligation');
  assertEquals(obligation.precondition, 'pre: x > 0');
  assertEquals(obligation.postcondition, 'post: result > 0');
  assertEquals(obligation.invariants.length, 1);
});

Deno.test('verifyObligation - returns verification result', () => {
  const obligation = proofObligation('Test', 'true', 'true');
  const result = verifyObligation(obligation);
  assertExists(result);
  assertEquals(result.property, 'Test');
  assertEquals(result.status, 'verified');
});
