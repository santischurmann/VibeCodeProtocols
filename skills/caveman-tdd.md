---
name: vcp-caveman-tdd
description: |
  ES: Reglas hard gate de TDD Caveman. Sin test rojo visible, no hay implementación. Sin excepciones.
  EN: Caveman TDD hard gate rules. No visible red test, no implementation. Zero exceptions.
allowed-tools: Read, Bash
---

# VCP Caveman TDD — Hard Gate Rules

**Caveman say: test fail first. Then make pass. Then make clean. In that order. Always.**

---

## THE THREE LAWS

1. **RED before GREEN.** No implementation without a failing test. Ever.
2. **GREEN before REFACTOR.** No cleanup on broken code.
3. **REFACTOR before DOCS.** Document the clean version.

**Hard gate #4, same rank: coverage ≥ 90% before SIMPLIFY/DEPLOY** (commands in COVERAGE GATE below).

**Precedence:** these gates override any speed/convenience heuristic. Definitions elsewhere: `SKILL.md` (phases, Phase 4 Final, full DoD), `skills/subagent-{red,green,refactor,docs}.md` (executors), `skills/deploy-zip.md` (optional artifact sub-step of 4.7). Gate wording conflicts → this file wins.

---

## HARD GATE VERIFICATION PROTOCOL

Before every GREEN subagent spawn, the orchestrator MUST run this check:

```bash
scripts/verify-red.sh "<test_pattern>" "<test_command>"
# Example: scripts/verify-red.sh "src/__tests__/auth.test.ts" "npx vitest run"
```

Script on disk = single source of truth — do NOT re-embed copies (they drift). Tests exit 0 (all pass) → 🚫 gate FAIL, no GREEN; nonzero → ✅ gate PASS.

**Blind spot — manual check mandatory:** ANY nonzero exit counts as PASS, but syntax/collection errors also exit nonzero. Failure output must show assertion failures or import-of-missing-module, NOT parse/collection errors. Parse error = fix test, re-run gate. Garbage tests make GREEN meaningless.

**Checkpoint (long tasks):** after every gate result, append one line to `.vibe/SESSION.md` (`T<id> RED gate PASS` / `GREEN ✅` / `REFACTOR green` / `coverage NN%`). Killed session must never skip a gate or blindly re-run a passed one.

---

## RESUME AFTER COMPACTION / RESTART

1. Re-read, in order: this file → `.vibe/SESSION.md` → `docs/tasks.json`.
2. Re-detect phase (never trust memory): run current task's tests. FAIL = pre-GREEN (RED done). PASS = post-GREEN.
3. `git diff` test files. Changed since RED = violation → stop, report.

---

## RED/GREEN/REFACTOR CHECKLIST

### RED Phase ✓
- [ ] Test file created at correct path
- [ ] Tests import the module under test (file may not exist yet — that's fine)
- [ ] Each Acceptance Criterion has at least one test
- [ ] Unit tests: one per AC minimum
- [ ] Integration tests: one per flow minimum
- [ ] E2E tests: one per user scenario minimum
- [ ] Tests run and FAIL (not error-out due to syntax — fail due to missing impl)
- [ ] Failure output captured and visible

### GREEN Phase ✓
- [ ] Implementation file created at correct path
- [ ] Implementation uses exact function/class names tests import
- [ ] All targeted tests PASS
- [ ] No previously-passing tests now fail (no regressions)
- [ ] No extra code beyond what tests require

### REFACTOR Phase ✓
- [ ] Baseline tests pass BEFORE any refactor edit
- [ ] Tests run after EACH edit — still green
- [ ] No new functionality added
- [ ] No test files modified
- [ ] Code is cleaner than before (naming, structure, duplication)
- [ ] Full suite passes at end

---

## COMMON VIOLATIONS AND HOW TO DETECT THEM

| Violation | Symptom | Detection |
|---|---|---|
| GREEN skips RED | Tests pass without implementation | RED gate script exits 0 |
| RED writes passing test | Gate fails at wrong place | Gate output shows 0 failures |
| GREEN over-engineers | Adds features not in tests | `git diff --stat` vs task JSON `files_to_create`/`files_to_modify` |
| REFACTOR adds feature | New code not covered by tests | Coverage drops on new lines — run COVERAGE GATE cmd |
| Subagent modifies tests | Tests change between RED and GREEN | `git diff` on test files |

---

## ANTI-RATIONALIZATIONS

These are common excuses to skip RED gate. All rejected.

| Excuse | Rebuttal |
|---|---|
| "The test structure is obvious" | Write it. Run it. Confirm it fails. 2 minutes. |
| "We're in a hurry" | Skipping RED creates bugs. Bugs take longer. |
| "The feature is simple" | Simple features are where most TDD violations happen. |
| "I'll write tests after" | That's not TDD. That's documentation. |
| "The test will obviously fail" | Run it anyway. Gate must confirm. |

---

## COVERAGE GATE

Minimum: **90%** (lines + branches)

```bash
# Node/TS — vitest (don't hide stderr — failures stay visible)
npx vitest run --coverage --coverage.reporter=json-summary
node -e "
  const d = JSON.parse(require('fs').readFileSync('coverage/coverage-summary.json','utf8'));
  const pct = d.total.lines.pct;
  console.log('Coverage:', pct + '%');
  process.exit(pct >= 90 ? 0 : 1);
"

# Python — pytest-cov
pytest --cov --cov-fail-under=90 2>&1 | tail -5

# Go
go test ./... -coverprofile=coverage.out && go tool cover -func=coverage.out | grep total
```

If coverage < 90%: do NOT proceed to Phase 4 (Final: simplify/security/adversarial/deploy). Spawn RED/GREEN cycle for uncovered paths.

Coverage gate ≠ done. Full DoD (SKILL.md Phase 4): suite green + lint 0 + typecheck 0 + cyber-neo clean + adversarial pass.
