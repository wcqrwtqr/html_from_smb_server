#!/usr/bin/env bash
source /usr/local/bin/bash_colors.sh


# TODO: export the data for 2024 and 2025 to files and if they are avialble then
# no need to run the find command on it while it has been ran before
# So the code will be ran for 2026 only 

> ./table_data.html
# Count of SQB
sqb_count24=$(find  "/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/SQB/2024/" -name "*.pdf" -and -name "*SQB*" | wc -l | tr -d ' ')
sqb_count25=$(find "/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/SQB/2025/" -name "*.pdf" -and -name "*SQB*" | wc -l | tr -d ' ')
sqb_count26=$(find  "/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/SQB/2026/" -name "*.pdf" -and -name "*SQB*" | wc -l | tr -d ' ')
{
    echo "<tbody>"
    echo "  <tr>"
    # echo "    <th scope=\"row\">$row_number</th>"
    echo "    <td>SQB Count</td>"
    echo "    <td>$sqb_count24</td>"
    echo "    <td>$sqb_count25</td>"
    echo "    <td>$sqb_count26</td>"
    echo "  </tr>"
    
} >> ./table_data.html 
# Count of final report
final_count24=$(find  "/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit1/Daily Report/2024/" -name "*.pdf" -and -name "*Final*" | wc -l | tr -d ' ')
final_count25=$(find "/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit1/Daily Report/2025/" -name "*.pdf" -and -name "*Final*" | wc -l | tr -d ' ')
final_count26=$(find  "/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit1/Daily Report/2026/" -name "*.pdf" -and -name "*Final*" | wc -l | tr -d ' ')
# Count of post wsd
{
    echo "  <tr>"
    # echo "    <th scope=\"row\">$row_number</th>"
    echo "    <td>Final report Count Unit-1</td>"
    echo "    <td>$final_count24</td>"
    echo "    <td>$final_count25</td>"
    echo "    <td>$final_count26</td>"
    echo "  </tr>"
    
} >> ./table_data.html 

final2_count24=$(find "/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit2/Daily Report/2024/" -name "*.pdf" -and -name "*Final*" | wc -l | tr -d ' ')
final2_count25=$(find "/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit2/Daily Report/2025/" -name "*.pdf" -and -name "*Final*" | wc -l | tr -d ' ')
final2_count26=$(find "/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit2/Daily Report/2026/" -name "*.pdf" -and -name "*Final*" | wc -l | tr -d ' ')
# Count of post wsd
{
    echo "  <tr>"
    # echo "    <th scope=\"row\">$row_number</th>"
    echo "    <td>Final report Count Unit-2</td>"
    echo "    <td>$final2_count24</td>"
    echo "    <td>$final2_count25</td>"
    echo "    <td>$final2_count26</td>"
    echo "  </tr>"
    echo "</tbody>"
    
} >> ./table_data.html 

# Count of certification

# cert_pce_count=$(find  "/Volumes/WL-SL/02 Slickline/02 Maintenance/PCE/" -name "EXP*" -not -path "*/EXPIRED/*" | wc -l | tr -d ' ')
# cert_other_count=$(find  "/Volumes/WL-SL/02 Slickline/02 Maintenance/" -name "EXP*" -not -path "*/EXPIRED*" -not -path "*/PCE/*" | wc -l | tr -d ' ')
# # printf "%s SQB report created in 2024\n" "$final_count24"
# # Count of post wsd
# {
#     echo "  <tr>"
#     # echo "    <th scope=\"row\">$row_number</th>"
#     echo "    <td>Valid Certificates PCE</td>"
#     echo "    <td>-</td>"
#     echo "    <td>-</td>"
#     echo "    <td>$cert_pce_count</td>"
#     echo "  </tr>"
    
# } >> ./table_data.html 

# {
#     echo "  <tr>"
#     # echo "    <th scope=\"row\">$row_number</th>"
#     echo "    <td>Valid Certificates other than PCE</td>"
#     echo "    <td>-</td>"
#     echo "    <td>-</td>"
#     echo "    <td>$cert_other_count</td>"
#     echo "  </tr>"
    
# } >> ./table_data.html 

echo -e "${MAGENTA}The file table_data.html${NC}"

