#!/usr/bin/env bash
# verify-red.sh — VibeCodeProtocols RED Gate verifier
# Usage: ./verify-red.sh "<test_pattern>" "<test_command>"
# Example: ./verify-red.sh "src/__tests__/auth.test.ts" "npx vitest run"

set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: verify-red.sh '<test_pattern>' '<test_command>'"
  echo "Example: verify-red.sh 'src/__tests__/auth.test.ts' 'npx vitest run'"
  exit 2
fi

TEST_PATTERN="$1"
TEST_CMD="$2"

echo "=== RED GATE VERIFICATION ==="
echo "Pattern: $TEST_PATTERN"
echo "Command: $TEST_CMD $TEST_PATTERN"
echo ""

set +e
output=$($TEST_CMD "$TEST_PATTERN" 2>&1)
exit_code=$?
set -e

echo "$output" | head -60
echo ""

if [ $exit_code -eq 0 ]; then
  echo "🚫 RED GATE: FAIL"
  echo ""
  echo "Tests PASSED — this should not happen before implementation."
  echo ""
  echo "Possible causes:"
  echo "  - Implementation file already exists"
  echo "  - Test imports a mock that returns correct value"
  echo "  - Wrong test file path (tests a different module)"
  echo "  - Tests are empty or using .todo() / .skip()"
  echo ""
  echo "Action: Fix test file or review implementation scope. Do NOT proceed to GREEN."
  exit 1
else
  # Count failures if possible
  fail_count=$(echo "$output" | grep -cE "(FAIL|FAILED|ERROR|failed|error)" 2>/dev/null || echo "?")
  echo "✅ RED GATE: PASS"
  echo "Tests failing as expected (approx $fail_count failure indicators)."
  echo "Proceed to GREEN subagent."
  exit 0
fi
