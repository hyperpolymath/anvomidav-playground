# SPDX-License-Identifier: AGPL-3.0-or-later
# SPDX-FileCopyrightText: 2026 hyperpolymath
#
# config.ncl - Nickel configuration for anvomidav-playground
# Provides typed, validated configuration for real-time verification playground

{
  # Project metadata
  project = {
    name = "anvomidav-playground",
    version = "0.1.0",
    description = "Playground for formally verified real-time systems",
    license = "AGPL-3.0-or-later",
    authors = ["hyperpolymath"],
    upstream = "hyperpolymath/anvomidav",
    kind = "playground",
  },

  # Runtime configuration
  runtime = {
    primary = "deno",
    version_constraint = ">=2.0.0",
    permissions = {
      read = true,
      write = false,
      net = false,
      env = false,
      run = false,
    },
  },

  # Timing specification surface
  timing = {
    # Base unit for all timing values
    base_unit = "microseconds",

    # Unit conversion aliases
    units = {
      us = 1,
      ms = 1000,
      s = 1000000,
    },

    # Task parameter constraints
    task_constraints = {
      wcet = {
        type = "number",
        description = "Worst-Case Execution Time",
        constraint = "wcet > 0",
      },
      deadline = {
        type = "number",
        description = "Relative deadline from task release",
        constraint = "deadline >= wcet",
      },
      period = {
        type = "number",
        description = "Task inter-arrival time",
        constraint = "period >= deadline",
      },
    },
  },

  # Schedulability analysis configuration
  schedulability = {
    # Supported scheduling policies
    policies = ["rate-monotonic", "deadline-monotonic", "edf"],

    # Default policy
    default_policy = "rate-monotonic",

    # Liu & Layland utilization bound: n * (2^(1/n) - 1)
    rm_bound = {
      formula = "n * (2^(1/n) - 1)",
      description = "Rate-Monotonic schedulability sufficient condition",
    },

    # Verdict types
    verdicts = {
      schedulable = {
        code = "SCHEDULABLE",
        description = "Task set is schedulable under the scheduling policy",
      },
      not_schedulable = {
        code = "NOT_SCHEDULABLE",
        description = "Task set exceeds utilization bound; may miss deadlines",
      },
      invalid = {
        code = "INVALID",
        description = "Task set violates timing constraints",
      },
    },
  },

  # Demo requirements per SPEC.playground.scm
  demo = {
    minimum_valid_scenarios = 2,
    minimum_invalid_scenarios = 2,
    output_determinism = true,
    network_dependency = false,
    real_time_dependency = false,

    # Pre-defined scenarios
    scenarios = {
      control_system_1 = {
        id = "control-system-1",
        name = "Basic Control System",
        expected_verdict = "SCHEDULABLE",
      },
      monitoring_system = {
        id = "monitoring-system",
        name = "High-Frequency Monitoring",
        expected_verdict = "SCHEDULABLE",
      },
      overloaded_system = {
        id = "overloaded-system",
        name = "Overloaded System",
        expected_verdict = "NOT_SCHEDULABLE",
      },
      invalid_wcet = {
        id = "invalid-wcet-exceeds-deadline",
        name = "WCET Exceeds Deadline",
        expected_verdict = "INVALID",
      },
      invalid_deadline = {
        id = "invalid-deadline-exceeds-period",
        name = "Deadline Exceeds Period",
        expected_verdict = "INVALID",
      },
    },
  },

  # Formal verification terminology
  terminology = {
    wcet = "Worst-Case Execution Time",
    deadline = "Maximum time allowed for task completion",
    period = "Time between successive task releases",
    utilization = "WCET / Period ratio",
    rm_bound = "Rate-Monotonic schedulability bound: n*(2^(1/n)-1)",
    proof_obligation = "Formal property that must be proven",
    precondition = "Condition that must hold before execution",
    postcondition = "Condition that must hold after execution",
    invariant = "Condition that must hold throughout execution",
  },

  # Testing configuration
  testing = {
    framework = "deno test",
    snapshot_tests = true,
    snapshot_location = "test/demo_snapshot_test.ts",

    # Test categories
    categories = {
      unit = {
        pattern = "test/*_test.ts",
        timeout_ms = 5000,
      },
      snapshot = {
        pattern = "test/*_snapshot_test.ts",
        timeout_ms = 10000,
      },
    },
  },

  # Development workflow
  workflow = {
    # Commands to run before commit
    pre_commit = ["just fmt", "just lint", "just test"],

    # Commands to run in CI
    ci_checks = ["just build", "just test", "just lint", "just verify", "just demo"],

    # Smoke tests for quick validation
    smoke_tests = ["deno task test", "deno task demo", "just demo"],
  },

  # RSR (Rhodium Standard Repository) compliance
  rsr = {
    current_tier = "bronze",
    target_tier = "silver",

    bronze_requirements = {
      license = true,
      readme = true,
      security_policy = true,
      code_of_conduct = true,
      contributing = true,
      changelog = true,
    },

    silver_requirements = {
      ci_pipeline = true,
      pinned_toolchain = true,
      snapshot_tests = true,
      signed_commits = false,
    },
  },
}
