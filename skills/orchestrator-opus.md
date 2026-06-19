---
name: vcp-orchestrator-opus
description: |
  ES: Referencia técnica del orquestador Opus — protocolo de delegación, DoD, flujo de subagentes.
  EN: Opus orchestrator technical reference — delegation protocol, DoD, subagent flow.
allowed-tools: Read, Write, Edit, Bash, Task, Agent, Glob, Grep, TodoWrite
---

# VCP Orchestrator — Opus Reference

This file defines the orchestration patterns used by the master SKILL.md.
The orchestrator (Opus) is the single responsible agent. Subagents (Sonnet) execute atomic tasks.

---

## DELEGATION PATTERN

For each task in `docs/tasks.json`, the orchestrator reads the relevant subagent skill file
and spawns the subagent with full context. Pattern:

```python
# Pseudocode — actual delegation via Agent tool
task = load_task("T01")

# Load subagent instructions
red_instructions = read_file("skills/subagent-red.md")

# Spawn with full context
Agent(
  subagent_type="claude",
  model="claude-sonnet-4-6",   # latest Sonnet
  prompt=f"""
{red_instructions}

---
## TASK CONTEXT

Task: {task.id} — {task.description}
Test files to write: {task.test_files}
Test types required: {task.test_types}
Implementation files (do NOT create yet): {task.files_to_create}
Spec: [read docs/spec.md]
"""
)
```

---

## SUBAGENT SEQUENCING PER TASK

```
Task T01:
  1. Spawn RED → wait for completion → verify failure output
  2. Run verify-red.sh (hard gate)
  3. If gate passes → spawn GREEN → wait → verify pass output
  4. If GREEN passes → spawn REFACTOR → wait → verify pass output
  5. Spawn DOCS → wait → confirm .vibe/ updated
  6. Update .vibe/SESSION.md
  7. Update tasks.json: T01 status → "done"
```

---

## PARALLEL vs SEQUENTIAL

**Sequential (required):** RED → GREEN → REFACTOR per task. Never parallel within a task.

**Parallel (allowed):** Tasks with no `depends_on` overlap can run in parallel across different task IDs.
Example: T01 and T03 have no overlap → spawn both RED subagents simultaneously.

**CHORE tasks:** Run CHORE after all tasks complete (lint, typecheck, coverage gate).

---

## FAILURE ESCALATION PROTOCOL

| Failure | Orchestrator action |
|---|---|
| RED gate fails (tests pass) | Ask user: "Tests pass without impl. Fix test file or create impl first?" (A/B/C) |
| GREEN fails (tests still red) | Read error output. Can orchestrator fix? If yes: spawn GREEN again with diagnosis. If no: ask user. |
| Coverage < 90% | Identify uncovered ACs. Create new tasks. Run RED/GREEN cycle. |
| Lint/typecheck errors | Spawn CHORE-A or CHORE-B. If CHORE can't fix: show error to user. |
| Build fails | Spawn CHORE-E. If still fails: show user full error output. |

---

## DEFINITION OF DONE (DoD) CHECKLIST

Before declaring any phase complete, verify:

### Phase 3 (BUILD) — per task:
- [ ] RED report shows test failure
- [ ] GREEN report shows test pass
- [ ] REFACTOR report shows tests still green
- [ ] No regressions in full suite

### Phase 4 (TEST):
- [ ] `<test_command> --run` exits 0
- [ ] Coverage ≥ 90% (json report confirms)
- [ ] `<lint_command>` exits 0
- [ ] `<typecheck_command>` exits 0

### Phase 5 (SIMPLIFY):
- [ ] Tests still green after cleanup
- [ ] No new lines without test coverage

### Phase 6 (DEPLOY):
- [ ] `dist/` exists and has expected artifacts
- [ ] `dist.zip` exists and is non-empty
- [ ] `checksums.txt` exists
- [ ] CHANGELOG.md has versioned entry
- [ ] `.vibe/SESSION.md` archived

---

## MULTIPLE CHOICE QUESTION TEMPLATE

```
🔵 DECISION: <topic>
Context: <why this choice matters>

A) <option> — Pro: <benefit>. Con: <tradeoff>.
B) <option> — Pro: <benefit>. Con: <tradeoff>.
C) <option> — Pro: <benefit>. Con: <tradeoff>.

Esperando tu respuesta antes de continuar. / Waiting for your answer before continuing.
```

---

## TODO TRACKING

The orchestrator uses TodoWrite to track phase progress:

```
Phase 0 Bootstrap      → [x] complete
Phase 1 SPEC           → [ ] in progress
Phase 2 PLAN           → [ ] pending
Phase 3 BUILD T01      → [ ] pending
Phase 3 BUILD T02      → [ ] pending
Phase 4 TEST           → [ ] pending
Phase 5 SIMPLIFY       → [ ] pending
Phase 6 DEPLOY         → [ ] pending
```

Update each item as phases complete.
