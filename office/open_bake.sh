#!/bin/bash
# ============================================================================
#  OPEN BAKE (Kitchen setup for bake users only)
# ============================================================================
# This script initializes a kitchen for projects using the `bake` command.
# The visible Makefile is left completely untouched.
# ============================================================================

# --- Formatting Helpers ---
_term_cols() { local cols; cols=$(stty size 2>/dev/null | awk '{print $2}'); [[ "$cols" =~ ^[0-9]+$ ]] && echo "$cols" || echo 80; }
WHITE='\033[1;37m'
NC='\033[0m'

STARTER() { local rule cols; cols=$(_term_cols); rule=$(awk -v n="$cols" 'BEGIN{while(i++<n)printf"━";print""}'); rule_thin=$(awk -v n="$cols" 'BEGIN{while(i++<n)printf"┈";print""}'); echo -e "${WHITE}${rule}${NC}"; echo -e "${WHITE}  $1${NC}"; echo -e "${WHITE}${rule_thin}${NC}"; }
FINISHED() { local rule cols; cols=$(_term_cols); rule=$(awk -v n="$cols" 'BEGIN{while(i++<n)printf"━";print""}'); rule_thin=$(awk -v n="$cols" 'BEGIN{while(i++<n)printf"┈";print""}'); echo -e "\n${WHITE}${rule_thin}${NC}"; echo -e "${WHITE}  $1${NC}"; echo -e "${WHITE}${rule}${NC}"; }

# Determine where this script lives so we can find the kitchen
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MAKERY_HOME="$(dirname "$SCRIPT_DIR")"

STARTER "LAYING THE FOUNDATION (Bake-only Setup)..."

# 1. Bring the Head Chef to this specific project
mkdir -p .makery/kitchen
cp -r "$MAKERY_HOME/kitchen/headchef" ".makery/kitchen/"

# 2. Create the internal menu wrapper (used by bake, keeps .makery self-contained)
cat > .makery/menu.mk << 'EOF'
-include kitchen/headchef/menu.mk
help:: menu
EOF

# 3. Set permissions for the Head Chef's orders
chmod +x .makery/kitchen/headchef/orders/*.sh

# 4. Hide the kitchen from Git
if [ -f ".gitignore" ]; then
    if ! grep -q "^\.makery/$" .gitignore; then
        echo -e "\n# --- MAKERY ---" >> .gitignore
        echo ".makery/" >> .gitignore
    fi
else
    echo ".makery/" > .gitignore
fi

# 5. Safety check: Ensure no local 'bake' file clutters the workspace
rm -f bake 2>/dev/null

FINISHED "✓ Local kitchen is open and ready."