---
name: VibeCodeProtocols
description: "TDD methodology for Claude Code: orchestrator runs under fableultracode contract, Sonnet 5 (low effort default) implements via 5 subagents (RED/GREEN/REFACTOR/DOCS/CHORE), .vibe/ persists memory. Final phase = fableultracode-orchestrated verify+simplify+security(cyber-neo)+adversarial+tests+commit/push/merge+backups. Hard gate: no red test = no code."
---

# VibeCodeProtocols — caveman edition

**Orchestrator run under `/fableultracode` contract, whole session. Sonnet 5 build tasks. Hard gate: red test first, always.**

Model split: orchestrator = you, wrapped in fableultracode (autonomy + rigor + comms contract, session-long). Build tasks = Sonnet 5, effort **low** default (config below).

---

## LAWS — non-negotiable

1. No red test seen → no impl. Zero exceptions.
2. 1 subagent = 1 atomic task. Never more.
3. Subagents don't decide architecture.
4. Orchestrator codes zero features — spec/plan/verify/simplify/security/deploy only.
5. Every gate → 1 line to `.vibe/SESSION.md` (resume ledger).
6. DoD: coverage ≥90% + lint 0 + typecheck 0 + docs + .vibe updated + security clean + adversarial pass.
7. Config menus (model/effort/detail) at phase start. Content menus (approve/modify) at decisions. Both wait for answer.

---

## PHASE 0 — BOOTSTRAP

1. **Invoke Skill `fableultracode`.** Contract active rest of session: autonomous execution, lead-with-outcome comms, evidence-gated state changes, code discipline, thinking_mode auto.
2. Detect stack: `ls package.json pyproject.toml go.mod Cargo.toml pom.xml 2>/dev/null`.
3. Read `.vibe/PROJECT.md` + `SESSION.md` + `DECISIONS.md` if exist.
4. **Resume check** — `SESSION.md` shows unfinished gate or `tasks.json` has non-`done` task → do NOT restart at SPEC. Re-detect phase with evidence (run that task's tests: FAIL=pre-GREEN, PASS=post-GREEN; `git diff` test files, changed-since-RED=violation stop). Never trust memory. Full protocol: `skills/caveman-tdd.md` § RESUME.
5. No `.vibe/` → create from `templates/vibe/`.
6. Report 1 line: memory loaded / new project.
7. 🔵 confirm detected stack (A approve / B correct).

---

## PHASE 1 — SPEC

🔵 **CONFIG** (ask once):
```
A) Detail: minimal (ACs only) / standard (+ constraints+non-goals) / exhaustive (+ risk notes)
B) Include non-goals section? Y/N
```

Generate `docs/spec.md` — template: `skills/spec-plan-templates.md`.

🔵 **CONTENT** review:
```
A) Approved — proceed to Plan
B) Modify: [specify]
C) Cancel
```

`.vibe/SESSION.md` += what/why specced.

---

## PHASE 2 — PLAN

🔵 **CONFIG** (ask once):
```
A) Task granularity: coarse (module-level) / atomic (1 fn/module, default) / hyper-atomic (split further)
B) Parallel build allowed for independent tasks? Y/N (default Y — see orchestrator-opus.md § PARALLEL)
```

Generate `docs/plan.md` + `docs/tasks.json` — template: `skills/spec-plan-templates.md`. Status lifecycle per task: `pending→red→green→refactor→done`.

🔵 **CONTENT** review:
```
A) Approved — start Build
B) Add/remove tasks: [specify]
C) Change order
D) Cancel
```

---

## PHASE 3 — BUILD (Sonnet 5 subagents, per task)

🔵 **CONFIG** (ask once before first task):
```
A) Model/effort: sonnet low (default, fast+cheap) / sonnet standard / sonnet high (complex logic)
B) Override per-task later if a task looks harder than expected? Y/N
```

Per task, topological order — full delegation pattern: `skills/orchestrator-opus.md`.

**3.1 RED** — `skills/subagent-red.md`. Spawn `model: sonnet, effort: <config>`.
Gate: `scripts/verify-red.sh "<pattern>" "<cmd>"`. Nonzero exit + assertion/missing-module failures (not parse errors) = ✅ pass → GREEN. Exit 0 = 🚫 blocked, report to user.

**3.2 GREEN** — `skills/subagent-green.md`. Verify PASS, no regressions.

**3.3 REFACTOR** — `skills/subagent-refactor.md`. Verify still green.

Checkpoint after each gate: 1 line `.vibe/SESSION.md` (`T<id> RED PASS` / `GREEN ✅` / `REFACTOR green`), `tasks.json` status bump.

Parallel: tasks with no `depends_on` overlap → spawn simultaneously (if config B=Y).

---

## PHASE 4 — FINAL (fableultracode-orchestrated close-out)

Re-affirm `/fableultracode` contract — this phase leans hardest on it: multi-agent fan-out + adversarial verify, not solo pass.

**4.1 Verify** — full suite + coverage + lint + typecheck:
```bash
<test_command_with_coverage>
<lint_command>
<typecheck_command>
```
Gate: coverage ≥90%, unit/integration/e2e all pass, lint 0, typecheck 0. Any fail → spawn `subagent-chore.md`, re-run.

**4.2 Simplify** — Boy Scout on all changed files (dead code, dup, premature abstraction, no new features). Tests green after each file. Diff summary → `.vibe/SESSION.md`.

**4.3 Security (cyber-neo)** — invoke Skill `cyber-neo` on the changeset. 11 categories, OWASP 2025 + CWE Top 25, 5 parallel subagents. Critical/High finding → fix before continuing, re-scan. Medium/Low → log to `.vibe/DEBT.md`, ask user severity call.

**4.4 Adversarial review** — fableultracode pattern: 3-5 independent skeptics per changed file/claim, prompted to refute (correctness / security / does-it-reproduce lenses). Kill/fix findings that survive majority refute. Never skip this to save tokens — degrade the mechanism (fewer votes) before dropping it.

**4.5 Tests (final)** — re-run full suite post-fixes from 4.3/4.4. Must be green — this is the last check before commit.

**4.6 Commit/push/merge**:
```bash
git add -A && git commit -m "<type>(<scope>): <what+why>"
```
Commit = reversible, do it. **Push/merge = show the exact command, ask 🔵 confirm first** — never automatic, never `--force`, never skip hooks.
```
🔵 A) git push origin <branch>
B) git push + open PR
C) Hold — don't push yet
```

**4.7 Backups**:
- Obsidian: if `Obsidian/07_Backups_Log/` exists → note with path, sha256, size (see any project's log for format).
- Graphify: if `graphify-out/` exists → `graphify update .` (AST-only, no API cost).
- `.vibe/SESSION.md` archived to `.vibe/sessions/YYYY-MM-DD-<topic>.md`, reset for next session.
- Optional distributable artifact (dist.zip+checksums): `skills/deploy-zip.md`, only if project ships one.

---

## CONFIG MENU PROTOCOL

Once per phase, before content decisions:
```
🔵 [PHASE] CONFIG
A) [option] — [default marked]
B) [option]
Waiting for answer before continuing.
```

## CONTENT DECISION PROTOCOL (unchanged)

```
🔵 [DECISION TOPIC]
[Context: why this matters]
A) [Option] — [trade-off]
B) [Option] — [trade-off]
Esperando tu respuesta antes de continuar.
```

---

## MEMORY UPDATES

| File | When | What |
|---|---|---|
| `SESSION.md` | every phase + every gate | 1 line per gate — resume ledger |
| `DECISIONS.md` | choosing between approaches | decision + reasoning |
| `PATTERNS.md` | discovering a project convention | pattern + example + when |
| `DEBT.md` | deferring cleanup, or 4.3 medium/low findings | what, where, severity, why deferred |
