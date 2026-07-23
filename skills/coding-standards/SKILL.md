---
name: coding-standards
description: Apply correct-by-construction TypeScript engineering standards covering boundary parsing, typed failures, domain modeling, module boundaries, dependency injection, testing, and type safety. Use when writing or reviewing TypeScript.
license: MIT
---

# TypeScript Coding Standards

Inspect the repository before introducing patterns, libraries, or abstractions. Follow compatible local conventions; contain incompatible legacy patterns at the nearest boundary instead of spreading them into new code.

## Priorities

1. Correctness, safety, and debuggability.
2. Explicit domain meaning and dependencies.
3. Compatibility with sound project conventions.
4. The narrowest change that fully solves the requested behavior.
5. Documentation for surprising, durable trade-offs.

## Parse at boundaries

Turn unknown or loosely shaped input into application and domain types as early as possible.

```ts
unknown -> protocol input -> parser -> domain/application input
```

A parser returns the refined value or a typed parsing failure. Do not validate and then continue carrying the original primitive or transport shape.

Use branded or refined types where they prevent realistic mistakes: identifiers, URLs, email addresses, money, units, constrained numbers, and non-empty values. Construct them through parsers or smart constructors.

## Expected failures are values

Known failures belong in return types. This includes parsing, authorization, configuration, persistence, I/O, integration, and workflow failures.

```ts
type Result<T, E extends Error> =
  | { readonly _tag: "ok"; readonly value: T }
  | { readonly _tag: "err"; readonly error: E };
```

Translate third-party exceptions inside the adapter that owns that dependency. Throw only for defects or impossible internal states. At entrypoints, turn expected failures into valid protocol outcomes: responses, exit codes, retry decisions, dead letters, or startup messages.

Custom errors should have a stable tag, useful safe context, and an optional `cause: unknown`. Never put secrets or raw credentials in errors, traces, snapshots, or logs.

## Model meaningful states

Make illegal states hard to construct. Prefer tagged unions over boolean combinations and nullable bags.

```ts
type Invoice =
  | { readonly _tag: "draft"; readonly id: InvoiceId }
  | { readonly _tag: "sent"; readonly id: InvoiceId; readonly sentAt: Instant }
  | { readonly _tag: "paid"; readonly id: InvoiceId; readonly paidAt: Instant };
```

Avoid boolean parameters that control behavior. Use named options or domain values.

## Module responsibilities

Use these roles when the behavior needs them; do not create layers to satisfy a diagram.

- **Domain module:** pure meanings, invariants, calculations, and legal transitions.
- **Application service:** authorization, policy, and sequencing across explicit ports.
- **Adapter:** framework, protocol, storage, runtime, or vendor translation.
- **Composition root:** configuration, resource acquisition, concrete wiring, and lifecycle.

Dependencies point inward. Domain code knows no framework or adapter. Application services depend on narrow application-owned ports, not SDK or database types. Adapters translate external types and failures at the edge.

Prefer deep cohesive modules: substantial behavior behind a small, meaningful interface. Avoid pass-through wrappers, repository-per-table defaults, vague managers/helpers, and abstractions created for one call site.

Before creating a service or adapter:

1. reuse an existing cohesive implementation through a narrow port;
2. extend it when the new behavior changes for the same reason;
3. create a new boundary only when reuse would create bad coupling.

## Effects and workflows

Keep pure decisions separate from I/O. Inject clocks, randomness, storage, and external clients.

Use ordinary calls and transactions for short single-boundary work. Use durable workflows only when progress must survive crashes, redelivery, long delays, compensation, human approval, or multiple transaction boundaries.

Any externally visible mutation that may be retried needs an explicit idempotency strategy. Do not hold database transactions open across network calls.

## Testing

Test behavior through public seams.

Prefer, in order:

1. end-to-end tests through real entrypoints;
2. integration tests through real boundaries;
3. focused or property tests for pure domain modules;
4. unit tests when they verify behavior rather than implementation.

Avoid module mocks, private-method tests, call-count assertions, and tautological expected values. Mock external boundaries only. Use test databases or local implementations when persistence semantics matter.

## TypeScript safety

Enable strict settings where practical, including `strict`, `noUncheckedIndexedAccess`, and `exactOptionalPropertyTypes`.

Prefer readonly inputs and outputs. Avoid `any`, non-null assertions, and unchecked casts. When TypeScript cannot express a proven invariant, isolate the cast and add a `// SAFETY:` comment explaining why it is sound.

Use direct imports from the owning file. Prefer `import type` for type-only dependencies. Avoid barrel files and vague `utils.ts` or `helpers.ts` modules unless they contain genuinely shared primitives.

Every exported symbol should have useful JSDoc. Document contracts, invariants, and failure behavior—not syntax already visible in the declaration.

## Completion checklist

- inputs are parsed at the edge
- domain states and identifiers are explicit
- expected failures are typed values
- external types remain inside adapters
- dependencies are injected through narrow ports
- existing modules were checked before adding new ones
- tests observe behavior through agreed public seams
- logs and errors contain no secrets
- casts and abstractions have a concrete justification
