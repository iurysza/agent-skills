---
name: brainstorming
description: Turn an early feature, product, component, or behavior idea into an approved design before implementation. Use when requirements, scope, interfaces, trade-offs, or success criteria still need discovery.
license: MIT
compatibility: Works with any agent that can inspect project context and ask the user questions.
---

# Brainstorming

Turn an idea into a design the user understands and approves before implementation starts.

## Design gate

Do not write implementation code, scaffold files, or change product behavior until the design is presented and approved. Scale the design to the task: a small change may need one short section; a system change may need several.

## Workflow

1. Inspect the project first: instructions, relevant files, documentation, tests, and recent changes.
2. Restate the goal, constraints, and known success criteria.
3. Identify what the project can answer and what only the user can decide.
4. Ask one focused question at a time. Prefer concrete options when they make the decision easier.
5. If the request contains independent systems, propose decomposition before refining details.
6. Present two or three viable approaches with trade-offs and a recommendation.
7. Present the design in reviewable sections and revise any rejected section.
8. Record the approved design when durable documentation would help.
9. Move to implementation planning only after explicit approval.

## Questions worth asking

Ask only questions that can change the design:

- Who is this for, and what problem must it solve?
- What is explicitly in or out of scope?
- What behavior proves success?
- Which constraints are fixed: compatibility, cost, latency, privacy, schedule, or operations?
- What failure behavior is acceptable?
- Which trade-off requires the user's preference?

Do not ask for facts available in the repository.

## Comparing approaches

For each credible approach, cover:

- core idea and ownership boundaries
- advantages under the stated constraints
- costs, risks, and irreversible choices
- effect on existing code and users
- verification strategy

Lead with the recommended approach and explain why it fits better. Do not invent a third option merely to fill a quota.

## Design coverage

Cover only sections relevant to the task:

- components and responsibilities
- interfaces and data flow
- state and persistence
- user-visible behavior
- errors, recovery, and observability
- security and privacy boundaries
- migration or rollout
- testing and acceptance criteria

Keep unresolved decisions visible. Approval of one section does not resolve a different open question.

## Final handoff

Before implementation, summarize:

- approved approach
- rejected alternatives and why
- scope boundaries
- acceptance criteria
- unresolved questions, if any

If unresolved questions can materially change the design, stop instead of declaring it ready.
