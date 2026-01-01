// SPDX-License-Identifier: AGPL-3.0-or-later
// SPDX-FileCopyrightText: 2026 hyperpolymath
//
// Anvomidav Playground - Schedulability Demo
// Produces deterministic verdicts for real-time task sets
//
// Per SPEC.playground.scm:
// - Outputs stable schedulability verdict for >=2 task sets
// - At least 2 invalid-spec cases fail deterministically
// - No network or real-time dependencies

// Time units in microseconds
type Microseconds = number;

// Timing specification for a real-time task
interface TaskSpec {
  name: string;
  wcet: Microseconds;
  deadline: Microseconds;
  period: Microseconds;
}

// Scenario for schedulability analysis
interface Scenario {
  id: string;
  name: string;
  description?: string;
  tasks: TaskSpec[];
}

// Verdict types per SPEC.playground.scm
type VerdictType = 'SCHEDULABLE' | 'NOT_SCHEDULABLE' | 'INVALID';

// Analysis result
interface Verdict {
  scenarioId: string;
  scenarioName: string;
  verdict: VerdictType;
  details: string[];
  error?: string;
}

// Validate a single task's timing constraints
function validateTask(task: TaskSpec): { valid: boolean; error?: string } {
  if (task.wcet <= 0) {
    return { valid: false, error: `wcet(${task.wcet}us) must be > 0` };
  }
  if (task.wcet > task.deadline) {
    return {
      valid: false,
      error: `wcet(${task.wcet}us) > deadline(${task.deadline}us)`,
    };
  }
  if (task.deadline > task.period) {
    return {
      valid: false,
      error: `deadline(${task.deadline}us) > period(${task.period}us)`,
    };
  }
  return { valid: true };
}

// Calculate task utilization
function taskUtilization(task: TaskSpec): number {
  return task.wcet / task.period;
}

// Rate-Monotonic schedulability bound: n * (2^(1/n) - 1)
function rmBound(n: number): number {
  return n * (Math.pow(2, 1 / n) - 1);
}

// Analyze a scenario and produce a verdict
function analyzeScenario(scenario: Scenario): Verdict {
  const details: string[] = [];

  // Validate all tasks first
  for (const task of scenario.tasks) {
    const validation = validateTask(task);
    if (!validation.valid) {
      return {
        scenarioId: scenario.id,
        scenarioName: scenario.name,
        verdict: 'INVALID',
        details: [],
        error: `Task '${task.name}' violates constraint: ${validation.error}`,
      };
    }
  }

  // Calculate total utilization
  const n = scenario.tasks.length;
  const totalUtilization = scenario.tasks.reduce((sum, task) => sum + taskUtilization(task), 0);
  const bound = rmBound(n);
  const margin = bound - totalUtilization;

  details.push(`Total utilization: ${(totalUtilization * 100).toFixed(2)}%`);
  details.push(`RM bound (${n} tasks): ${(bound * 100).toFixed(2)}%`);
  details.push(`Margin: ${(margin * 100).toFixed(2)}%`);

  const verdict: VerdictType = totalUtilization <= bound ? 'SCHEDULABLE' : 'NOT_SCHEDULABLE';

  return {
    scenarioId: scenario.id,
    scenarioName: scenario.name,
    verdict,
    details,
  };
}

// Format verdict for output (per SPEC.playground.scm format)
function formatVerdict(verdict: Verdict): string {
  const lines: string[] = [];
  lines.push('---');
  lines.push(`SCENARIO: ${verdict.scenarioId} (${verdict.scenarioName})`);
  lines.push(`VERDICT: ${verdict.verdict}`);

  if (verdict.error) {
    lines.push(`ERROR: ${verdict.error}`);
  } else if (verdict.details.length > 0) {
    lines.push('DETAILS:');
    for (const detail of verdict.details) {
      lines.push(`  - ${detail}`);
    }
  }

  lines.push('---');
  return lines.join('\n');
}

// ============================================================================
// DEMO SCENARIOS
// Per golden-path success-criteria:
// - At least 2 valid task sets with schedulability verdicts
// - At least 2 invalid-spec cases that fail deterministically
// ============================================================================

const scenarios: Scenario[] = [
  // VALID SCENARIO 1: Basic Control System (schedulable)
  {
    id: 'control-system-1',
    name: 'Basic Control System',
    description: 'Typical sensor-compute-actuate control loop',
    tasks: [
      { name: 'sensor', wcet: 1000, deadline: 5000, period: 10000 },
      { name: 'compute', wcet: 10000, deadline: 40000, period: 50000 },
      { name: 'actuate', wcet: 5000, deadline: 80000, period: 100000 },
    ],
  },

  // VALID SCENARIO 2: High-Frequency Monitoring (schedulable)
  {
    id: 'monitoring-system',
    name: 'High-Frequency Monitoring',
    description: 'Fast sampling with slower processing',
    tasks: [
      { name: 'sample', wcet: 500, deadline: 1000, period: 2000 },
      { name: 'filter', wcet: 2000, deadline: 8000, period: 10000 },
      { name: 'log', wcet: 5000, deadline: 40000, period: 50000 },
    ],
  },

  // VALID SCENARIO 3: Overloaded System (not schedulable)
  {
    id: 'overloaded-system',
    name: 'Overloaded System',
    description: 'Task set exceeds RM bound',
    tasks: [
      { name: 'fast-task', wcet: 8000, deadline: 10000, period: 10000 },
      { name: 'medium-task', wcet: 15000, deadline: 20000, period: 20000 },
      { name: 'slow-task', wcet: 25000, deadline: 50000, period: 50000 },
    ],
  },

  // INVALID SCENARIO 1: WCET exceeds deadline
  {
    id: 'invalid-wcet-exceeds-deadline',
    name: 'WCET Exceeds Deadline',
    description: 'Task with WCET greater than deadline',
    tasks: [{ name: 'bad-task', wcet: 10000, deadline: 5000, period: 20000 }],
  },

  // INVALID SCENARIO 2: Deadline exceeds period
  {
    id: 'invalid-deadline-exceeds-period',
    name: 'Deadline Exceeds Period',
    description: 'Task with deadline greater than period',
    tasks: [{ name: 'bad-deadline', wcet: 5000, deadline: 30000, period: 20000 }],
  },
];

// Run the demo
function runDemo(): string {
  const output: string[] = [];

  output.push('================================================================================');
  output.push('ANVOMIDAV PLAYGROUND - SCHEDULABILITY DEMO');
  output.push('================================================================================');
  output.push('');
  output.push('Analyzing task sets for Rate-Monotonic schedulability...');
  output.push('');

  let validCount = 0;
  let invalidCount = 0;
  let schedulableCount = 0;
  let notSchedulableCount = 0;

  for (const scenario of scenarios) {
    const verdict = analyzeScenario(scenario);
    output.push(formatVerdict(verdict));
    output.push('');

    if (verdict.verdict === 'INVALID') {
      invalidCount++;
    } else {
      validCount++;
      if (verdict.verdict === 'SCHEDULABLE') {
        schedulableCount++;
      } else {
        notSchedulableCount++;
      }
    }
  }

  output.push('================================================================================');
  output.push('SUMMARY');
  output.push('================================================================================');
  output.push(`Total scenarios analyzed: ${scenarios.length}`);
  output.push(`  - Valid specifications: ${validCount}`);
  output.push(`    - SCHEDULABLE: ${schedulableCount}`);
  output.push(`    - NOT_SCHEDULABLE: ${notSchedulableCount}`);
  output.push(`  - Invalid specifications: ${invalidCount}`);
  output.push('================================================================================');

  return output.join('\n');
}

// Main entry point
if (import.meta.main) {
  console.log(runDemo());
}

export { analyzeScenario, formatVerdict, runDemo, scenarios };
export type { Scenario, TaskSpec, Verdict, VerdictType };
