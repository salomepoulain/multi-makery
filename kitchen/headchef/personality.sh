# ============================================================================
#  HEAD CHEF: PERSONALITY & FORMATTING HELPERS
# ============================================================================


# --- Colors & Styling ---
# Rainbow spectrum
RED='\033[1;31m'
ORANGE='\033[38;5;208m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
MAGENTA='\033[1;35m'

# Neutrals
BLACK='\033[1;30m'
WHITE='\033[1;37m'
GRAY='\033[1;90m'
BROWN='\033[38;5;94m'

# Text styling
BOLD='\033[1m'
DIM='\033[2m'
ITALIC='\033[3m'
NC='\033[0m'



# SELECT IDENTITY 
# -----------------------------------------------------
COOK_ICON="✦"
COOK_NAME="headchef"
COOK_COLOR="$BROWN"

_HC_ID_VISIBLE_OFFSET=1
# ------------------------------------------------------




# Fixed column width for the icon+name slot; pad with spaces when shorter
_HC_PREFIX_WIDTH=12

_calc_hc_id_visible_len() {
    echo $((${#COOK_ICON} + ${#COOK_NAME} + 1 + ${_HC_ID_VISIBLE_OFFSET:-0}))
}

# --- Helpers ---
_term_cols() {
    local cols
    cols=$(stty size 2>/dev/null | awk '{print $2}')
    [[ "$cols" =~ ^[0-9]+$ ]] && echo "$cols" || echo 80
}

# --- Head Chef Functions ---
STARTER() {
    local rule cols
    cols=$(_term_cols)
    rule=$(awk -v n="$cols" 'BEGIN{while(i++<n)printf"━";print""}')
    rule_thin=$(awk -v n="$cols" 'BEGIN{while(i++<n)printf"┈";print""}')
    echo -e "${COOK_COLOR}${rule}${NC}"
    echo -e "${COOK_COLOR}  $1${NC}"
    echo -e "${COOK_COLOR}${rule_thin}${NC}\n"
}

DONE() {
    local rule cols
    cols=$(_term_cols)
    rule=$(awk -v n="$cols" 'BEGIN{while(i++<n)printf"━";print""}')
    rule_thin=$(awk -v n="$cols" 'BEGIN{while(i++<n)printf"┈";print""}')
    echo -e "\n${COOK_COLOR}${rule_thin}${NC}"
    echo -e "${COOK_COLOR}  BAKE FINISHED${NC}"
    echo -e "${COOK_COLOR}${rule}${NC}"

}

SAY() {
    local cols msg_width msg_start_col pad spaces cont_indent id_visible_len
    cols=$(_term_cols)
    id_visible_len=$(_calc_hc_id_visible_len)
    msg_start_col=$(( _HC_PREFIX_WIDTH + 3 ))
    msg_width=$(( cols - msg_start_col ))
    [[ "$msg_width" -lt 20 ]] && msg_width=20

    pad=$(( _HC_PREFIX_WIDTH - id_visible_len ))
    spaces=$(printf '%*s' "$pad" '')
    cont_indent=$(printf '%*s' "$msg_start_col" '')

    local first=1
    echo "$1" | fold -sw "$msg_width" | while IFS= read -r line; do
        if [[ "$first" -eq 1 ]]; then
            echo -e "  ${COOK_COLOR}${COOK_ICON} $COOK_NAME:${NC}${spaces} ${ITALIC}${DIM}${line}${NC}"
            first=0
        else
            echo -e "${cont_indent}${ITALIC}${DIM}${line}${NC}"
        fi
    done
}
