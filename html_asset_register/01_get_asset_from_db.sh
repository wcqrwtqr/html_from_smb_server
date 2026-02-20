#!/usr/bin/env bash
source /usr/local/bin/bash_colors.sh

set -euo pipefail

# This code used to read the database ~/org/Exported_database_2026_noes.csv
# and if it is not available then it will generate it

asset_list="./pdf_list_certificate.txt"
coc_list="./pdf_list_coc.txt"
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
        echo "    <td>$category</td>"
        echo "    <td>$rating</td>"
        echo "    <td>$comment</td>"

        # Search for MPI links
        mpi_sn=$(awk -F, -v sn="$sn" '$0 ~ "MPI.*" sn {print $2; exit}' "${asset_list}" | sed 's|/Volumes/WL-SL|..|g' | tr -d '"')
        if [[ -n $mpi_sn ]]; then
            echo "    <td class='bg-success text-center'> <a href=\"$mpi_sn\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">MPI</a> </td>"
        else
            echo "    <td class='bg-danger text-center'>NA</td>"
        fi 

        # Search for UTM links
        utm_sn=$(awk -F, -v sn="$sn" '$0 ~ "UTM.*" sn {print $2; exit}' "${asset_list}" | sed 's|/Volumes/WL-SL|..|g' | tr -d '"')
        if [[ -n $utm_sn ]]; then
            echo "    <td class='bg-success text-center'> <a href=\"$utm_sn\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">UTM</a> </td>"
        else
            echo "    <td class='bg-danger text-center'>NA</td>"
        fi 
        # Search for PT links
        pt_sn=$(awk -F, -v sn="$sn" '$0 ~ "PT.*" sn {print $2; exit}' "${asset_list}" | sed 's|/Volumes/WL-SL|..|g' | tr -d '"')
        if [[ -n $pt_sn ]]; then
            echo "    <td class='bg-success text-center'> <a href=\"$pt_sn\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">PT</a> </td>"
        else
            echo "    <td class='bg-danger text-center'>NA</td>"
        fi 
        # Search for Calibration links
        cal_sn=$(awk -F, -v sn="$sn" '$0 ~ "Calib.*" sn {print $2; exit}' "${asset_list}" | sed 's|/Volumes/WL-SL|..|g' | tr -d '"')
        if [[ -n $cal_sn ]]; then
            echo "    <td class='bg-success text-center'> <a href=\"$cal_sn\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">Calib</a> </td>"
        else
            echo "    <td class='bg-danger text-center'>NA</td>"
        fi 
        # Search for COC links
        coc_sn=$(awk -F, -v sn="$sn" '$1 ~ sn "ICC1" {print $2; exit}' "${coc_list}" | sed 's|/Volumes/WL-SL|..|g' | tr -d '"')
        if [[ -n $coc_sn ]]; then
            echo "    <td class='bg-success text-center'> <a href=\"$coc_sn\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">COC</a> </td>"
        else
            echo "    <td class='bg-danger text-center text-white'>NA</td>"
        fi 

        echo "  </tr>"

        ((row_number++))
    done

    echo "</tbody>"
} > "$output_file"

echo -e "${MAGENTA}Results have been saved to $output_file${NC}"
