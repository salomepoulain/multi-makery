#!/bin/bash
# Test headchef commands via make

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

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

# Create temp directory for testing
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

echo "Testing headchef commands..."
echo "Using temp directory: $TEMP_DIR"

cd "$TEMP_DIR"

# Set up a minimal makery environment
mkdir -p .makery/kitchen/headchef/orders
cp -r "$PROJECT_ROOT/kitchen/headchef/menu.mk" .makery/kitchen/headchef/
cp "$PROJECT_ROOT/kitchen/headchef/orders/inspo.sh" .makery/kitchen/headchef/orders/
cp "$PROJECT_ROOT/kitchen/headchef/orders/fresh.sh" .makery/kitchen/headchef/orders/
chmod +x .makery/kitchen/headchef/orders/*.sh

# Create a minimal Makefile
cat > Makefile << 'EOF'
.PHONY: menu germs

-include .makery/kitchen/headchef/menu.mk
.DEFAULT_GOAL := menu
EOF

# Test 1: make menu
if make menu 2>/dev/null | grep -q "Head Chef's Menu"; then
    pass "make menu displays menu"
else
    fail "make menu did not display expected content"
fi

# Test 2: germs command (works with no stations)
if make germs 2>/dev/null; then
    pass "make germs runs without error"
else
    fail "make germs failed"
fi

# Test 3: Verify the headchef menu.mk has the correct targets
if grep -q "^menu::" "$PROJECT_ROOT/kitchen/headchef/menu.mk"; then
    pass "menu target defined in headchef/menu.mk"
else
    fail "menu target not found in headchef/menu.mk"
fi

if grep -q "^germs::" "$PROJECT_ROOT/kitchen/headchef/menu.mk"; then
    pass "germs target defined in headchef/menu.mk"
else
    fail "germs target not found in headchef/menu.mk"
fi

if grep -q "^first::" "$PROJECT_ROOT/kitchen/headchef/menu.mk"; then
    pass "first target defined in headchef/menu.mk"
else
    fail "first target not found in headchef/menu.mk"
fi

if grep -q "^burnt::" "$PROJECT_ROOT/kitchen/headchef/menu.mk"; then
    pass "burnt target defined in headchef/menu.mk"
else
    fail "burnt target not found in headchef/menu.mk"
fi

if grep -q "^fresh::" "$PROJECT_ROOT/kitchen/headchef/menu.mk"; then
    pass "fresh target defined in headchef/menu.mk"
else
    fail "fresh target not found in headchef/menu.mk"
fi

if grep -q "^call::" "$PROJECT_ROOT/kitchen/headchef/menu.mk"; then
    pass "call target defined in headchef/menu.mk"
else
    fail "call target not found in headchef/menu.mk"
fi

echo ""
echo "All headchef command tests passed!"