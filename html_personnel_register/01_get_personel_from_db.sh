#!/usr/bin/env bash
source /usr/local/bin/bash_colors.sh

set -euo pipefail

# This code used to read the database ~/org/Exported_database_2026_noes_personnel.csv
# and if it is not available then it will generate it

personel_list="./pdf_list_personnel.txt"
input_file="$HOME/org/Exported_database_2026_noes_personnel.csv"
output_file="personnel_table.html"

if [[ ! -f "$personel_list" ]]; then
    echo -e "${RED}Certificates file from html_sls_certificate is not available${NC}"
    exit 1
fi 

if [[ ! -f "$HOME/org/Exported_database_2026_noes_personnel.csv" ]]; then
    echo -e "${RED}The databse file is not available... Creating a new one${NC}" &&
        sqlite3 -header -csv ./neosdatabase.db "SELECT * FROM personnel_sl;" > $HOME/org/Exported_database_2026_noes_personnel.csv
fi
row_number=1

{
    echo "<tbody>"

    # Skip header, process data rows only
    tail -n +2 "$input_file" | while IFS=',' read -r id FullName \
        Grade Position DateOfJoin ; do
        # Remove surrounding quotes from description
        # description=$(echo "$description" | tr -d '"')
        fullname=$(echo "${FullName}" | tr -d '"')
        echo "  <tr>"
        echo "    <th scope=\"row\">$row_number</th>"
        # echo "    <td>$id</td>"
        echo "    <td>$fullname</td>"
        # echo "    <td>$Position</td>"

        # Search for FF links
        ff_cert=$(awk -F, -v name="$fullname" '$0 ~ /FF/ && $0 ~ name {print $2; exit}' "${personel_list}" | sed 's|/Volumes/WL-SL|..|g' | tr -d '"')
        if [[ -n $ff_cert ]]; then
            echo "    <td class='ff bg-success text-center'> <a href=\"$ff_cert\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">FF</a> </td>"
        else
            echo "    <td class='ff bg-danger text-center'>NA</td>"
        fi 

        # Search for FA links
        fa_cert=$(awk -F, -v name="$fullname" '$0 ~ /FA/ && $0 ~ name {print $2; exit}' "${personel_list}" | sed 's|/Volumes/WL-SL|..|g' | tr -d '"')
        if [[ -n $fa_cert ]]; then
            echo "    <td class='fa bg-success text-center'> <a href=\"$fa_cert\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">FA</a> </td>"
        else
            echo "    <td class='fa bg-danger text-center'>NA</td>"
        fi 

        # Search for H2S links
        h2s_cert=$(awk -F, -v name="$fullname" '$0 ~ /H2S/ && $0 ~ name {print $2; exit}' "${personel_list}" | sed 's|/Volumes/WL-SL|..|g' | tr -d '"')
        if [[ -n $h2s_cert ]]; then
            echo "    <td class='h2s bg-success text-center'> <a href=\"$h2s_cert\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">H2S</a> </td>"
        else
            echo "    <td class='h2s bg-danger text-center'>NA</td>"
        fi 

        # Search for WAH links
        wah_cert=$(awk -F, -v name="$fullname" '$0 ~ /WAH/ && $0 ~ name {print $2; exit}' "${personel_list}" | sed 's|/Volumes/WL-SL|..|g' | tr -d '"')
        if [[ -n $wah_cert ]]; then
            echo "    <td class='wah bg-success text-center'> <a href=\"$wah_cert\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">WAH</a> </td>"
        else
            echo "    <td class='wah bg-danger text-center'>NA</td>"
        fi 

        # Search for Lifting links
        lift_cert=$(awk -F, -v name="$fullname" '$0 ~ /Lifting/ && $0 ~ name {print $2; exit}' "${personel_list}" | sed 's|/Volumes/WL-SL|..|g' | tr -d '"')
        if [[ -n $lift_cert ]]; then
            echo "    <td class='lift bg-success text-center'> <a href=\"$lift_cert\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">Lifting</a> </td>"
        else
            echo "    <td class='lift bg-danger text-center'>NA</td>"

        fi 

        # Search for AGT links
        agt_cert=$(awk -F, -v name="$fullname" '$0 ~ /AGT/ && $0 ~ name {print $2; exit}' "${personel_list}" | sed 's|/Volumes/WL-SL|..|g' | tr -d '"')
        if [[ -n $agt_cert ]]; then
            echo "    <td class='agt bg-success text-center'> <a href=\"$agt_cert\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">AGT</a> </td>"
        else
            echo "    <td class='agt bg-danger text-center'>NA</td>"
        fi 

        # Search for Banksman links
        bank_cert=$(awk -F, -v name="$fullname" '$0 ~ /Banks/ && $0 ~ name {print $2; exit}' "${personel_list}" | sed 's|/Volumes/WL-SL|..|g' | tr -d '"')
        if [[ -n $bank_cert ]]; then
            echo "    <td class='bank bg-success text-center'> <a href=\"$bank_cert\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">Banksman</a> </td>"
        else
            echo "    <td class='bank bg-danger text-center'>NA</td>"
        fi 
        # Search for Crane Operator links
        cran_cert=$(awk -F, -v name="$fullname" '$0 ~ /Crane/ && $0 ~ name {print $2; exit}' "${personel_list}" | sed 's|/Volumes/WL-SL|..|g' | tr -d '"')
        if [[ -n $cran_cert ]]; then
            echo "    <td class='crane bg-success text-center'> <a href=\"$cran_cert\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">Crane-Op</a> </td>"
        else
            echo "    <td class='crane bg-danger text-center'>NA</td>"
        fi 
        # Search for IWCF links
        iwcf_cert=$(awk -F, -v name="$fullname" '$0 ~ /IWCF/ && $0 ~ name {print $2; exit}' "${personel_list}" | sed 's|/Volumes/WL-SL|..|g' | tr -d '"')
        if [[ -n $iwcf_cert ]]; then
            echo "    <td class='iwcf bg-success text-center'> <a href=\"$iwcf_cert\" target=\"_blank\" class=\"text-white fw-bold text-decoration-none\">IWCF</a> </td>"
        else
            echo "    <td class='iwcf bg-danger text-center'>NA</td>"
        fi 

        echo "  </tr>"

        ((row_number++))
    done

    echo "</tbody>"
} > "$output_file"

echo -e "${MAGENTA}Results have been saved to $output_file${NC}"
