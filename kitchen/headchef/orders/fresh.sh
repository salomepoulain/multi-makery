#!/bin/bash
# ============================================================================
#  HEAD CHEF: GERMS (Health Inspector is coming)
# ============================================================================

echo -e "\033[1;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;34m  KILLING GERMS (Health Inspector Prep) \033[0m"
echo -e "\033[1;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

clean_station() {
    local station_dir=$1
    local station_name=$(basename "$station_dir")
    local cleaned=false
    
    if [ -f "$station_dir/workbench/.dishsoap" ]; then
        while IFS= read -r path_to_clean || [ -n "$path_to_clean" ]; do
            if [[ -z "$path_to_clean" || "$path_to_clean" == #* ]]; then continue; fi
            if [ -e "$path_to_clean" ]; then
                rm -rf "$path_to_clean"
                if [ "$cleaned" = false ]; then
                     echo -e "\n\033[1mThe cook is scrubbing the '$station_name' workbench:\033[0m"
                     cleaned=true
                fi
                echo "      - Scrubbed: $path_to_clean"
            fi
        done < "$station_dir/workbench/.dishsoap"
    fi
}

if [ -n "$1" ]; then
    # Clean just one station
    if [ -d ".makery/kitchen/stations/$1" ]; then
        clean_station ".makery/kitchen/stations/$1"
    else
        echo -e "\033[1;33mThe '$1' station doesn't exist.\033[0m"
    fi
else
    # Clean all stations
    echo "  [.] The Head Chef is screaming. Everyone is scrubbing their workbenches!"
    for dir in .makery/kitchen/stations/*/; do
        if [ ! -d "$dir" ]; then continue; fi
        clean_station "$dir"
    done
fi

echo -e "\n\033[1;32m  ✓ The kitchen is spotless. We will pass the inspection.\033[0m"
echo -e "\033[1;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n"
