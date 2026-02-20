#!/usr/bin/env bash
source /usr/local/bin/bash_colors.sh

set -euo pipefail

# This code used to read the database ~/org/Exported_database_2026_noes.csv
# and if it is not available then it will generate it

asset_list="./pdf_list_certificate.txt"
input_file="$HOME/org/Exported_database_2026_noes.csv"
output_file="assets_table.html"

if [[ ! -f "$asset_list" ]]; then
    echo -e "${RED}Certificates file from html_sls_certificate is not available${NC}"
    exit 1
fi 

if [[ ! -f "$HOME/org/Exported_database_2026_noes.csv" ]]; then
    echo -e "${RED}The databse file is not available... Creating a new one${NC}" &&
        sqlite3 -header -csv $HOME/org/neosdatabase.db "SELECT * FROM sl_equipment;" > $HOME/org/Exported_database_2026_noes.csv
fi
row_number=1

{
    echo "<tbody>"

    # Skip header, process data rows only
    tail -n +2 "$input_file" | while IFS=',' read -r id sn description type size \
        tag manufacturer comment bl inOperation category isAsset rating; do
        # Remove surrounding quotes from description
        description=$(echo "$description" | tr -d '"')
        echo "  <tr>"
        echo "    <th scope=\"row\">$row_number</th>"
        echo "    <td>$sn</td>"
        echo "    <td>$type</td>"
        echo "    <td>$description</td>"
        echo "    <td>$size</td>"
        echo "    <td>$tag</td>"
        echo "    <td>$manufacturer</td>"
        echo "    <td>$bl</td>"
        # if [[ $inOperation -eq 1 ]]; then
        #     echo "    <td>Yes</td>"
        # else
        #     echo "    <td>No</td>"
        # fi
        echo "    <td>$category</td>"
        echo "    <td>$rating</td>"
        echo "    <td>$comment</td>"
        if grep -q "MPI.*${sn}" "${asset_list}"; then
            echo "    <td style='background-color:Green;'>MPI</td>"
        else
            echo "    <td style='background-color:Tomato;'>NA</td>"
        fi
        if grep -q "UTM.*${sn}" "${asset_list}"; then
            echo "    <td style='background-color:Green;'>UTM</td>"
        else
            echo "    <td style='background-color:Tomato;'>NA</td>"
        fi
        if grep -q "PT.*${sn}" "${asset_list}"; then
            echo "    <td style='background-color:Green;'>PT</td>"
        else
            echo "    <td style='background-color:Tomato;'>NA</td>"
        fi
        if grep -q "Calibr.*${sn}" "${asset_list}"; then
            echo "    <td style='background-color:Green;'>Calib</td>"
        else
            echo "    <td style='background-color:Tomato;'>NA</td>"
        fi
        echo "  </tr>"

        ((row_number++))
    done

    echo "</tbody>"
} > "$output_file"

echo -e "${MAGENTA}Results have been saved to $output_file${NC}"
