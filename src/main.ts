// SPDX-License-Identifier: AGPL-3.0-or-later
// SPDX-FileCopyrightText: 2025 hyperpolymath
//
// Anvomidav Playground - Main Entry Point
// Demonstrates formally verified real-time systems

/**
 * Anvomidav Playground
 *
 * This playground demonstrates formally verified real-time systems:
 * - WCET (Worst-Case Execution Time) analysis
 * - Schedulability verification
 * - Real-time task scheduling
 * - Formal proof obligations
 */

// Time units in microseconds
type Microseconds = number;

// Timing specification for a real-time task
interface TimingSpec {
  wcet: Microseconds;      // Worst-case execution time
  deadline: Microseconds;  // Task deadline
  period: Microseconds;    // Task period
}

// Verified real-time task
interface VerifiedTask {
  name: string;
  timing: TimingSpec;
  verified: boolean;
  proofStatus: 'proven' | 'pending' | 'failed';
}

// Create a timing specification
function timingSpec(
  wcetMicroseconds: number,
  deadlineMicroseconds: number,
  periodMicroseconds: number
): TimingSpec {
  return {
    wcet: wcetMicroseconds,
    deadline: deadlineMicroseconds,
    period: periodMicroseconds,
  };
}

// Verify WCET constraint: WCET <= Deadline
function verifyWcetDeadline(timing: TimingSpec): boolean {
  const verified = timing.wcet <= timing.deadline;
  console.log(
    `  WCET(${timing.wcet}us) <= Deadline(${timing.deadline}us): ${verified ? 'VERIFIED' : 'FAILED'}`
  );
  return verified;
}

// Verify deadline constraint: Deadline <= Period
function verifyDeadlinePeriod(timing: TimingSpec): boolean {
  const verified = timing.deadline <= timing.period;
  console.log(
    `  Deadline(${timing.deadline}us) <= Period(${timing.period}us): ${verified ? 'VERIFIED' : 'FAILED'}`
  );
  return verified;
}

// Calculate utilization for a task
function taskUtilization(timing: TimingSpec): number {
  return timing.wcet / timing.period;
}

// Rate-Monotonic schedulability test (Liu & Layland bound)
// For n tasks, schedulable if U <= n * (2^(1/n) - 1)
function rateMonotonicBound(n: number): number {
  return n * (Math.pow(2, 1 / n) - 1);
}

// Verify schedulability of task set
function verifySchedulability(tasks: VerifiedTask[]): boolean {
  const n = tasks.length;
  const totalUtilization = tasks.reduce(
    (sum, task) => sum + taskUtilization(task.timing),
    0
  );
  const bound = rateMonotonicBound(n);

  console.log(`\n  Task set utilization: ${(totalUtilization * 100).toFixed(2)}%`);
  console.log(`  RM bound for ${n} tasks: ${(bound * 100).toFixed(2)}%`);

  const schedulable = totalUtilization <= bound;
  console.log(`  Schedulable: ${schedulable ? 'YES' : 'NO'}`);

  return schedulable;
}

// Create a verified task
function createVerifiedTask(
  name: string,
  wcetMicroseconds: number,
  deadlineMicroseconds: number,
  periodMicroseconds: number
): VerifiedTask {
  const timing = timingSpec(wcetMicroseconds, deadlineMicroseconds, periodMicroseconds);

  console.log(`\nVerifying task: ${name}`);
  const wcetOk = verifyWcetDeadline(timing);
  const deadlineOk = verifyDeadlinePeriod(timing);
  const verified = wcetOk && deadlineOk;

  return {
    name,
    timing,
    verified,
    proofStatus: verified ? 'proven' : 'failed',
  };
}

// Demonstrate real-time verification
function demonstrateRealTimeVerification(): void {
  console.log('=== Anvomidav Playground ===\n');
  console.log('Demonstrating formally verified real-time systems:\n');

  // Create task set (typical control system)
  console.log('1. Creating verified task set:');

  const sensorTask = createVerifiedTask(
    'SensorRead',
    1000,   // 1ms WCET
    5000,   // 5ms deadline
    10000   // 10ms period
  );

  const computeTask = createVerifiedTask(
    'Compute',
    10000,  // 10ms WCET
    40000,  // 40ms deadline
    50000   // 50ms period
  );

  const actuateTask = createVerifiedTask(
    'Actuate',
    5000,   // 5ms WCET
    80000,  // 80ms deadline
    100000  // 100ms period
  );

  // Verify schedulability
  console.log('\n2. Verifying schedulability:');
  const tasks = [sensorTask, computeTask, actuateTask];
  const schedulable = verifySchedulability(tasks);

  // Summary
  console.log('\n3. Verification Summary:');
  for (const task of tasks) {
    console.log(`  ${task.name}: ${task.proofStatus.toUpperCase()}`);
  }
  console.log(`  Task Set Schedulable: ${schedulable ? 'PROVEN' : 'FAILED'}`);

  console.log('\n=== Demo Complete ===');
}

// Run if executed directly
if (import.meta.main) {
  demonstrateRealTimeVerification();
}

export {
  TimingSpec,
  VerifiedTask,
  timingSpec,
  verifyWcetDeadline,
  verifyDeadlinePeriod,
  taskUtilization,
  verifySchedulability,
  createVerifiedTask,
  demonstrateRealTimeVerification,
};
