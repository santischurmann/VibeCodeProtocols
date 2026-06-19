---
name: vcp-spec-plan-templates
description: |
  ES: Templates embebidos para spec.md, plan.md, tasks.json y ADRs.
  EN: Embedded templates for spec.md, plan.md, tasks.json, and ADRs.
allowed-tools: Read, Write, Edit
---

# VCP Templates

Use these templates verbatim. Replace `<placeholders>` with actual content.

---

## TEMPLATE: docs/spec.md

```markdown
# Spec: <feature-name>

**Date:** <YYYY-MM-DD>
**Version:** 1.0
**Author:** Opus (VibeCodeProtocols)
**Status:** Draft | Approved

---

## Problem / Problema

<1-3 sentences describing what problem this solves.>

---

## Target Users / Usuarios

<Who uses this? Role, context, frequency.>

---

## Acceptance Criteria / Criterios de aceptación

Each criterion is testable. Use GIVEN/WHEN/THEN format.

- [ ] **AC1:** GIVEN <initial state>, WHEN <action>, THEN <expected result>
- [ ] **AC2:** GIVEN <initial state>, WHEN <action>, THEN <expected result>
- [ ] **AC3 (edge case):** GIVEN <edge condition>, WHEN <action>, THEN <expected result>
- [ ] **AC4 (error):** GIVEN <invalid input>, WHEN <action>, THEN <error is [type] with message [X]>

---

## Constraints / Restricciones

- <Technical constraint: must use X library, must not break Y API>
- <Performance: response time < N ms>
- <Security: no user data in logs>

---

## Non-Goals / No-Goals

This spec does NOT cover:
- <Explicit exclusion 1>
- <Explicit exclusion 2>

---

## Stack & Dependencies

- **Language/Runtime:** <detected or specified>
- **Test runner:** <vitest | pytest | go test | ...>
- **New dependencies:** <none | package@version — reason>

---

## Definition of Done (DoD)

- [ ] All ACs pass (unit + integration + e2e tests)
- [ ] Coverage ≥ 90%
- [ ] Lint: 0 errors
- [ ] Typecheck: 0 errors
- [ ] README updated (if user-facing)
- [ ] CHANGELOG entry added
- [ ] .vibe/ updated
```

---

## TEMPLATE: docs/plan.md

```markdown
# Plan: <feature-name>

**Date:** <YYYY-MM-DD>
**Spec:** [docs/spec.md](./spec.md)
**Status:** Draft | Approved

---

## Task Breakdown

| ID | Description | Files | Subagents | Depends on |
|----|-------------|-------|-----------|------------|
| T01 | <atomic task> | <files> | RED, GREEN, REFACTOR | — |
| T02 | <atomic task> | <files> | RED, GREEN, REFACTOR | T01 |

---

## Execution Order (topological)

1. T01 — <description>
2. T02 — <description> (requires T01)

---

## Risk Notes

- <Risk: T03 touches shared module — run full suite after>
- <Risk: T02 requires external API — mock in unit tests, real in integration>

---

## Estimated sessions

<N> tasks × ~[time estimate each] = ~[total] (rough)
```

---

## TEMPLATE: docs/tasks.json

```json
{
  "feature": "<feature-name>",
  "spec": "docs/spec.md",
  "created": "YYYY-MM-DD",
  "tasks": [
    {
      "id": "T01",
      "description": "One atomic action — one function or module",
      "files_to_create": ["src/feature/module.ts"],
      "files_to_modify": [],
      "test_files": ["src/__tests__/module.test.ts"],
      "test_types": ["unit", "integration", "e2e"],
      "subagents": ["red", "green", "refactor"],
      "depends_on": [],
      "status": "pending"
    },
    {
      "id": "T02",
      "description": "Another atomic action",
      "files_to_create": [],
      "files_to_modify": ["src/feature/module.ts"],
      "test_files": ["src/__tests__/module.integration.test.ts"],
      "test_types": ["integration"],
      "subagents": ["red", "green", "refactor"],
      "depends_on": ["T01"],
      "status": "pending"
    }
  ]
}
```

---

## TEMPLATE: docs/adr/<NNNN>-<title>.md

```markdown
# ADR <NNNN>: <title>

**Date:** <YYYY-MM-DD>
**Status:** Proposed | Accepted | Deprecated | Superseded by ADR-NNNN

---

## Context

<What situation forced this decision?>

## Decision

<What was decided, stated in active voice.>

## Options Considered

**Option A — <name>**
- Pros: 
- Cons:

**Option B — <name>**
- Pros:
- Cons:

**Chosen:** Option A
**Reason:** <why>

## Consequences

<What becomes easier or harder as a result?>
```
