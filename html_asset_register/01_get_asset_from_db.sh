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
find_link() {
    local file="$1"
    local pattern="$2"
    local result
    result=$(awk -F, -v pat="$pattern" '$0 ~ pat {print $2; exit}' "$file" | sed 's|/Volumes/My Passport for Mac/NEOS/Server Backup/WL-SL|..|g' | tr -d '"')
    if [[ -n "$result" ]]; then
        echo "<td class='bg-success text-center'> <a href=\"$result\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">$3</a> </td>"
    else
        echo "<td class='bg-danger text-center text-white'>NA</td>"
    fi
}

if [[ ! -f "$asset_list" ]]; then
    echo -e "${RED}Certificates file from html_sls_certificate is not available${NC}"
    exit 1
fi 

if [[ ! -f "$HOME/org/Exported_database_2026_noes.csv" ]]; then
    echo -e "${RED}The databse file is not available... Creating a new one${NC}" &&
        sqlite3 -header -csv $HOME/org/neosdatabase.db "SELECT * FROM sl_equipment;" > $HOME/org/Exported_database_2026_noes.csv
fi


{
    echo "<tbody>"
    row_number=1

    # Process data rows
    tail -n +2 "$input_file" | while IFS=',' read -r id sn description type size \
        tag manufacturer comment bl inOperation category isAsset rating; do
        
        desc=$(echo "$description" | tr -d '"')

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
        # Print links using helper function
        find_link "$asset_list" "MPI.*$sn" "MPI"
        find_link "$asset_list" "UTM.*$sn" "UTM"
        find_link "$asset_list" "PT.*$sn" "PT"
        find_link "$asset_list" "Calib.*$sn" "Calib"
        find_link "$coc_list" "$sn""ICC1" "COC"

        echo "  </tr>"
        ((row_number++))
    done
    echo "</tbody>"
} > "$output_file"


echo -e "${MAGENTA}Results have been saved to $output_file${NC}"
