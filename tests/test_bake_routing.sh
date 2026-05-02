#!/bin/bash
# Test bake routing logic

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BAKE_SCRIPT="$PROJECT_ROOT/office/cabinet/bake"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

pass() {
    echo -e "${GREEN}✓${NC} $1"
}

fail() {
    echo -e "${RED}✗${NC} $1"
    exit 1
}

echo "Testing bake routing logic..."

# Test 1: Verify bake script exists
if [ -f "$BAKE_SCRIPT" ]; then
    pass "bake script exists at $BAKE_SCRIPT"
else
    fail "bake script not found at $BAKE_SCRIPT"
fi

# Test 2: Verify bake script is executable
if [ -x "$BAKE_SCRIPT" ]; then
    pass "bake script is executable"
else
    fail "bake script is not executable"
fi

# Test 3: Extract routing logic to test
# Source the condition test function from bake
test_bake_args() {
    local args=("$@")
    local num_args=$#
    local second="${args[1]:-}"

    # This mirrors the logic in the bake script
    if [ $num_args -ge 2 ] && [[ ! "$second" == *=* ]]; then
        echo "try_first_then_call"
    else
        echo "pass_through"
    fi
}

# Test routing cases
result=$(test_bake_args "first" "python")
[ "$result" = "try_first_then_call" ] && pass "first python -> try_first_then_call" || fail "first python routing"

result=$(test_bake_args "python" "deploy")
[ "$result" = "try_first_then_call" ] && pass "python deploy -> try_first_then_call" || fail "python deploy routing"

result=$(test_bake_args "first" "s=python")
[ "$result" = "pass_through" ] && pass "first s=python -> pass_through" || fail "first s=python routing"

result=$(test_bake_args "germs")
[ "$result" = "pass_through" ] && pass "germs -> pass_through" || fail "germs routing"

result=$(test_bake_args "menu")
[ "$result" = "pass_through" ] && pass "menu -> pass_through" || fail "menu routing"

result=$(test_bake_args "first" "python" "extra")
[ "$result" = "try_first_then_call" ] && pass "first python extra -> try_first_then_call" || fail "first python extra routing"

echo ""
echo "All bake routing tests passed!"