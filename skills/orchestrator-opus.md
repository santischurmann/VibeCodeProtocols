---
name: vcp-orchestrator-opus
description: |
  ES: Referencia técnica del orquestador — protocolo de delegación, DoD, flujo de subagentes, contrato fableultracode.
  EN: Orchestrator technical reference — delegation protocol, DoD, subagent flow, fableultracode contract.
allowed-tools: Read, Write, Edit, Bash, Task, Agent, Glob, Grep, TodoWrite, Skill
---

# VCP Orchestrator Reference

Orchestrator = single responsible agent, runs under `/fableultracode` contract (Phase 0 → session-long): autonomy, lead-with-outcome comms, evidence-gated actions. Subagents (Sonnet 5, effort per Phase 3 config) execute atomic tasks — no fableultracode wrapper on them, they just build.

---

## DELEGATION PATTERN

For each task in `docs/tasks.json`, read the subagent skill file, spawn with full context:

```python
# Pseudocode — actual delegation via Agent tool
task = load_task("T01")
red_instructions = read_file("skills/subagent-red.md")

Agent(
  subagent_type="claude",
  model="sonnet",           # alias, always latest Sonnet
  effort=config.effort,     # from Phase 3 CONFIG menu — default "low"
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

If a task looks harder mid-build and config allowed override (Phase 3 CONFIG, option B) → bump that task's effort, note why in `.vibe/SESSION.md`.

---

## SUBAGENT SEQUENCING PER TASK

```
Task T01:
  1. Spawn RED → wait → verify failure output
  2. Run verify-red.sh (hard gate)
  3. Gate pass → spawn GREEN → wait → verify pass
  4. GREEN pass → spawn REFACTOR → wait → verify still pass
  5. Spawn DOCS → wait → confirm .vibe/ updated
  6. .vibe/SESSION.md += 1 line per gate (resume ledger)
  7. tasks.json: T01 status → done (pending→red→green→refactor→done)
```

---

## PARALLEL vs SEQUENTIAL

**Sequential, always:** RED → GREEN → REFACTOR within one task.

**Parallel, if Phase 2 CONFIG allowed it:** tasks with no `depends_on` overlap spawn simultaneously. T01 + T03 no overlap → both RED subagents at once.

**CHORE:** after all tasks done (lint, typecheck, coverage) — also reusable inside Phase 4.1/4.3 for fixes.

---

## FAILURE ESCALATION

| Failure | Action |
|---|---|
| RED gate fails (tests pass) | Ask user: fix test file or impl first? (A/B) |
| GREEN fails (still red) | Read error. Orchestrator can fix → respawn GREEN w/ diagnosis. Can't → ask user. |
| Coverage < 90% (Phase 4.1) | Identify uncovered ACs, new tasks, RED/GREEN cycle. |
| Lint/typecheck errors | Spawn CHORE-A/B. Can't fix → show user. |
| cyber-neo finds Critical/High (Phase 4.3) | Fix before continuing, re-scan. Never defer critical/high. |
| Adversarial review finding survives (Phase 4.4) | Fix, re-verify, re-run that lens. |
| Session killed / compacted mid-task | RESUME protocol below. Never re-run a passed gate blind, never skip a pending one. |

---

## RESUME AFTER RESTART / COMPACTION

1. Re-read: `.vibe/SESSION.md` (gate ledger) → `docs/tasks.json` (status).
2. First task not `done` = current. Re-detect phase with evidence: run its tests (FAIL=pre-GREEN, PASS=post-GREEN). Never trust memory.
3. `git diff` its test files — changed since RED = violation, stop, report.
4. Continue sequencing from detected step. Gate rules: `skills/caveman-tdd.md`.
5. If restart lands inside Phase 4 (Final) — re-check which of 4.1-4.7 last completed via `SESSION.md`, resume from next.

---

## DEFINITION OF DONE (DoD) CHECKLIST

### Phase 3 BUILD — per task:
- [ ] RED report: failure shown
- [ ] GREEN report: pass shown
- [ ] REFACTOR report: still green
- [ ] No regressions full suite

### Phase 4 FINAL:
- [ ] 4.1 coverage ≥90%, lint 0, typecheck 0
- [ ] 4.2 tests green after simplify
- [ ] 4.3 cyber-neo clean (no open Critical/High)
- [ ] 4.4 adversarial review: no surviving finding
- [ ] 4.5 full suite green (post-fix)
- [ ] 4.6 committed; push/merge only after user 🔵 confirm
- [ ] 4.7 Obsidian note (if applicable) + graphify updated (if applicable) + SESSION.md archived

---

## MULTIPLE CHOICE TEMPLATES

**Config (phase-start, once):**
```
🔵 [PHASE] CONFIG
A) [option, default marked]
B) [option]
Waiting for answer before continuing.
```

**Content decision:**
```
🔵 DECISION: <topic>
Context: <why this matters>
A) <option> — Pro/Con
B) <option> — Pro/Con
Esperando tu respuesta antes de continuar.
```

---

## TODO TRACKING

```
Phase 0 Bootstrap (+fableultracode) → [x]
Phase 1 SPEC                        → [ ]
Phase 2 PLAN                        → [ ]
Phase 3 BUILD T01..TNN               → [ ]
Phase 4 FINAL
  4.1 Verify   → [ ]
  4.2 Simplify → [ ]
  4.3 Security (cyber-neo) → [ ]
  4.4 Adversarial review   → [ ]
  4.5 Tests (final)        → [ ]
  4.6 Commit/push/merge    → [ ]
  4.7 Backups              → [ ]
```
