---
name: VibeCodeProtocols
description: |
  ES: Metodología completa TDD con orquestación Opus+Sonnet y memoria persistente en .vibe/.
  Activar para: construir features, refactorizar, iniciar proyectos, cualquier tarea de desarrollo no trivial.
  EN: Complete TDD programming methodology. Opus orchestrates, Sonnet implements, memory in .vibe/.
  Activate for: build feature, refactor, start project, implement X, any non-trivial development task.
allowed-tools: Read, Write, Edit, Bash, Task, Glob, Grep, Agent, TodoWrite
---

# VibeCodeProtocols — TDD Orchestrator

**Model assignment / Asignación de modelos:**
- **Opus** (this skill): spec, plan, verify, simplify, deploy, orchestration
- **Sonnet** (subagents): RED tests, GREEN implementation, REFACTOR, DOCS, CHORE

---

## RULES — NON-NEGOTIABLE / REGLAS INNEGOCIABLES

1. **No red test visible → no implementation. Hard gate. Zero exceptions.**
2. One subagent = one atomic task. Never more.
3. Subagents do NOT make architectural decisions.
4. Opus does NOT code features — only spec/plan/verify/simplify/deploy.
5. Every phase end → update `.vibe/SESSION.md`.
6. DoD: coverage ≥90% + lint 0 + typecheck 0 + docs updated + .vibe updated.
7. Present multiple-choice questions at every significant decision. Wait for answer before continuing.

---

## PHASE 0 — BOOTSTRAP

```bash
# Auto-detect stack
ls package.json pyproject.toml go.mod Cargo.toml pom.xml 2>/dev/null | head -5
```

Steps:
1. Read `.vibe/PROJECT.md`, `.vibe/SESSION.md`, `.vibe/DECISIONS.md` if they exist.
2. If `.vibe/` missing → create it with templates from `templates/vibe/`.
3. Report: "📋 Memory loaded: [project summary]" or "🆕 New project — initializing .vibe/"
4. Detect: test runner, linter, typechecker, builder from project manifest.
5. Ask user to confirm detected stack before proceeding.

**Stack detection matrix:**
| File found | Stack | Test runner | Linter | Typecheck |
|---|---|---|---|---|
| package.json + tsconfig | TypeScript/Node | vitest or jest | eslint | tsc |
| pyproject.toml / setup.py | Python | pytest | ruff | mypy |
| go.mod | Go | go test | golangci-lint | go vet |
| Cargo.toml | Rust | cargo test | clippy | cargo check |
| pom.xml | Java | mvn test | checkstyle | javac |

---

## PHASE 1 — SPEC (Opus)

Generate `docs/spec.md`. Use template format:

```markdown
# Spec: <feature-name>
**Date:** YYYY-MM-DD | **Author:** Opus (VibeCodeProtocols)

## Problem / Problema
## Target users / Usuarios
## Acceptance Criteria / Criterios de aceptación
- [ ] GIVEN ... WHEN ... THEN ... (Gherkin-style, testable)
## Constraints / Restricciones
## Non-goals / No-goals
## Stack & dependencies
## Definition of Done (DoD)
```

**REQUIRED:** Present spec → ask user:

```
🔵 SPEC REVIEW
A) Approved — proceed to Plan
B) Modify: [specify what]
C) Cancel
```

Save to `.vibe/SESSION.md`: what was specced and why.

---

## PHASE 2 — PLAN (Opus)

Generate `docs/plan.md` + `docs/tasks.json`.

Each task must include:
```json
{
  "id": "T01",
  "description": "one function or module — atomic",
  "files_to_create": [],
  "files_to_modify": [],
  "test_files": [],
  "test_types": ["unit", "integration", "e2e"],
  "subagents": ["red", "green", "refactor"],
  "depends_on": []
}
```

**REQUIRED:** Present plan → ask user:

```
🔵 PLAN REVIEW
A) Approved — start Build
B) Add/remove tasks: [specify]
C) Change order
D) Cancel
```

---

## PHASE 3 — BUILD (Sonnet subagents per task)

For each task in topological order:

### 3.1 — RED (Sonnet subagent)

Read `skills/subagent-red.md`. Spawn:
```
Agent(
  subagent_type="claude",
  model="sonnet",
  prompt=<contents of skills/subagent-red.md> + "\n\n## TASK\n" + <task JSON>
)
```

**HARD GATE — verify before continuing:**
```bash
# Run tests — must see FAILURE output
<detected_test_command>
```
- Output shows failures → ✅ gate passed, continue to GREEN.
- Output shows all pass → 🚫 BLOCKED. Report: "RED GATE FAIL: Task [id]. Tests pass before implementation exists. Review test file."
- Error running tests → fix environment, retry once. If still fails → escalate to user.

### 3.2 — GREEN (Sonnet subagent)

Read `skills/subagent-green.md`. Spawn with task context.

Verify: `<test_command>` shows PASS.

### 3.3 — REFACTOR (Sonnet subagent)

Read `skills/subagent-refactor.md`. Spawn with task context.

Verify: tests still PASS after refactor.

Update `.vibe/SESSION.md` after each task.

---

## PHASE 4 — TEST (Opus)

Run full test suite. Measure coverage. Check lint and typecheck.

```bash
# Collect and show full output — do not suppress failures
<test_command_with_coverage>
<lint_command>
<typecheck_command>
```

**DoD gates:**
- [ ] Coverage ≥ 90%
- [ ] Unit: all pass
- [ ] Integration: all pass
- [ ] E2E: all scenarios pass
- [ ] Lint: 0 errors
- [ ] Typecheck: 0 errors

If any gate fails → spawn subagent-chore to fix, then re-run full suite.

---

## PHASE 5 — SIMPLIFY (Opus)

Apply Boy Scout Rule to all changed files:
- Remove dead code and unused imports
- Eliminate duplication (extract shared logic)
- Remove premature abstractions
- No new features during this phase

Run tests after each file simplified. Must stay green.

Save simplification diff summary to `.vibe/SESSION.md`.

---

## PHASE 6 — DEPLOY (Opus)

Read `skills/deploy-zip.md` for full protocol.

Required outputs:
- Production build in `dist/`
- `dist.zip` + `checksums.txt` (SHA256)
- `CHANGELOG.md` updated with release notes from `.vibe/SESSION.md`
- Semantic version tag committed

---

## MULTIPLE CHOICE PROTOCOL

At every significant decision, present options before acting:

```
🔵 [DECISION TOPIC]
[Context: why this matters]

A) [Option] — [Trade-off]
B) [Option] — [Trade-off]
C) [Option] — [Trade-off]

Esperando tu respuesta (A/B/C) antes de continuar.
Waiting for your answer (A/B/C) before continuing.
```

---

## MEMORY UPDATES

After each phase, update `.vibe/`:

| File | When | What |
|---|---|---|
| `SESSION.md` | Every phase | What happened, output, issues |
| `DECISIONS.md` | When choosing approach | Decision + reasoning |
| `PATTERNS.md` | When discovering conventions | How things are done here |
| `DEBT.md` | When deferring cleanup | What and why deferred |
