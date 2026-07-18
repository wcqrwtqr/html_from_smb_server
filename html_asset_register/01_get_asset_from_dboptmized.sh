#!/usr/bin/env bash
source /usr/local/bin/bash_colors.sh

set -euo pipefail

# This code used to read the database ~/org/Exported_database_2026_noes.csv
# and if it is not available then it will generate it

asset_list="./pdf_list_certificate.txt" # Generated from asset certification and moved here
coc_list="./pdf_list_coc.txt" # Generated from COC page
input_file="$HOME/org/Exported_database_2026_noes.csv"
output_file="assets_table.html"
# Helper function to find links

set -euo pipefail

asset_list="./pdf_list_certificate.txt"
coc_list="./pdf_list_coc.txt"
input_file="$HOME/org/Exported_database_2026_noes.csv"
output_file="assets_table.html"

if [[ ! -f "$asset_list" ]]; then
    echo -e "${RED}Certificates file is not available${NC}"
    exit 1
fi 

if [[ ! -f "$input_file" ]]; then
    echo -e "${RED}Database file missing. Generating...${NC}"
    sqlite3 -header -csv "$HOME/org/neosdatabase.db" "SELECT * FROM sl_equipment;" > "$input_file"
fi

# Optimization: Load files into memory (Associative Arrays)
# This will make the search near-instant instead of 1 minute!
declare -A LOOKUP
while IFS=',' read -r _ path _; do
    path=${path//\"/} # remove quotes
    # Extract SN from the path string based on your logic
    # This assumes the SN is part of the filename structure
    # You may need to adjust the regex to match your specific file naming
    sn=$(echo "$path" | grep -oE '[A-Z0-9-]{5,}') 
    LOOKUP["$sn"]="$path"
done < "$asset_list"

# Function to get link from memory
get_link() {
    local sn="$1"
    local type="$2"
    local val="${LOOKUP[$sn]:-}" # Look up in memory
    if [[ -n "$val" ]]; then
        val=${val//\/Volumes\/My Passport for Mac\/NEOS\/Server Backup\/WL-SL/..}
        echo "<td class='bg-success text-center'> <a href=\"$val\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">$type</a> </td>"
    else
        echo "<td class='bg-danger text-center text-white'>NA</td>"
    fi
}


generate_table() {
    echo "<tbody>"
    row_number=1
    while IFS=',' read -r id sn description type size tag manufacturer comment bl inOperation category isAsset rating; do
        desc=${description//\"/}
        cat <<EOF
  <tr>
    <th scope="row">$row_number</th>
    <td>$sn</td>
    <td>$type</td>
    <td>$desc</td>
    <td>$size</td>
    <td>$tag</td>
    <td>$manufacturer</td>
    <td>$bl</td>
    <td>$category</td>
    <td>$rating</td>
    <td>$comment</td>
EOF
        get_link "$sn" 'MPI'
        get_link "$sn" 'UTM'
        get_link "$sn" 'PT'
        get_link "$sn" 'Calib'
        get_link "$sn" 'COC'
        echo "  </tr>"
        ((row_number++))
    done < <(tail -n +2 "$input_file")
    echo "</tbody>"
}

# Run the function with the spinner
gum spin --spinner dot --title "Generating assets table..." -- generate_table > "$output_file"


echo -e "${MAGENTA}Results have been saved to $output_file${NC}"
