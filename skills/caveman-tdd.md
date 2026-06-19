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

---

## HARD GATE VERIFICATION PROTOCOL

Before every GREEN subagent spawn, the orchestrator MUST run this check:

```bash
#!/usr/bin/env bash
# verify-red.sh — run by orchestrator after RED subagent completes
set -euo pipefail

TEST_PATTERN="${1:?Usage: verify-red.sh <test_file_pattern>}"
TEST_CMD="${2:?Usage: verify-red.sh <pattern> <test_command>}"

echo "=== RED GATE CHECK ==="
echo "Running: $TEST_CMD $TEST_PATTERN"
echo ""

# Run tests and capture exit code
set +e
output=$($TEST_CMD "$TEST_PATTERN" 2>&1)
exit_code=$?
set -e

echo "$output" | head -50

if [ $exit_code -eq 0 ]; then
  echo ""
  echo "🚫 RED GATE: FAIL"
  echo "Tests PASSED — no implementation should make them pass yet."
  echo "Action: Review test file. Tests may be importing mocks, testing wrong thing, or file already has implementation."
  exit 1
else
  echo ""
  echo "✅ RED GATE: PASS"
  echo "Tests failing as expected. Proceed to GREEN subagent."
  exit 0
fi
```

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
| GREEN over-engineers | Adds features not in tests | Review new files/functions vs task scope |
| REFACTOR adds feature | New code not covered by tests | Coverage drops on new lines |
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
# Node/TS — vitest
npx vitest run --coverage --coverage.reporter=json-summary 2>/dev/null
cat coverage/coverage-summary.json | node -e "
  const d = JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));
  const pct = d.total.lines.pct;
  console.log('Coverage:', pct + '%');
  process.exit(pct >= 90 ? 0 : 1);
"

# Python — pytest-cov
pytest --cov --cov-fail-under=90 2>&1 | tail -5

# Go
go test ./... -coverprofile=coverage.out && go tool cover -func=coverage.out | grep total
```

If coverage < 90%: do NOT proceed to SIMPLIFY or DEPLOY. Spawn RED/GREEN cycle for uncovered paths.
