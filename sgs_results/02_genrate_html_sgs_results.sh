#!/usr/bin/env bash
source /usr/local/bin/bash_colors.sh

# Define the input file and output HTML file
input_file_u1="pdf_list_sgs_results_2026.txt"
output_file_u1="output_sgs_results_u1.html"

if [[ ! -f "$input_file_u1" ]]; then
    echo -e "${RED}The $input_file_u1 is not available${NC}"
    exit 1
fi


# Initialize the row counter
row_number=1

# Open the output file for writing
{
    echo "<tbody>"

    # Loop through each line in the input file
    while IFS=, read -r p_max t_max duration pdf_path unit_no; do

        # This code is optimized code suggested from Gemini as my previous code
        # was calling for echo, awk, cut repeatedly 
        # 1. Get the filename from the path
        filename="${pdf_path##*/}"
        
        # 2. Extract Date: Last underscore + remove extension (assuming 8-digit date)
        # R-671_SGS Data_8700_Top_20241019.txt -> 20241019
        raw_date="${filename%.*}"
        raw_date="${raw_date##*_}"
        sgs_date="${raw_date:0:4}-${raw_date:4:2}-${raw_date:6:2}"

        # 3. Extract Well: The part before the first underscore in the filename
        sgs_well="${filename%%_*}"

        # 4. Math: Use $(( )) directly
        dur_hr=$(( duration / 3600 ))

        # Output the formatted HTML row
        cat <<EOF
        <tr>
            <th scope="row">$row_number</th>
            <td>$sgs_well</td>
            <td>$sgs_date</td>
            <td>$p_max</td>
            <td>$t_max</td>
            <td>$dur_hr</td>
            <td>$unit_no</td>
            <td><a href="$pdf_path" target="_blank">link</a></td>
        </tr>
EOF
        # Increment the row counter
        ((row_number++))
    done <"$input_file_u1"
    echo "</tbody>"
    echo "<tfoot id="tableFooter" class="table-group-divider"></tfoot>"
} >"$output_file_u1"


echo -e "${YELLOW}HTML rows generated in $output_file_u1${NC}"
