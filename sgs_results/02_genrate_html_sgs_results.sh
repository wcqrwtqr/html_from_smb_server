#!/usr/bin/env bash
source /usr/local/bin/bash_colors.sh

# Define the input file and output HTML file
input_file_u1="pdf_list_sgs_results_u1.txt"
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
        # Extract the date of the sgs
        sgs_date=$(echo "$pdf_path" | awk -F_ '{print $NF}' | cut -d "." -f 1)
        sgs_well=$(echo "$pdf_path"| awk -F"/" '{print $10}' | cut -d "_" -f 2)
        dur_hr=$(echo $(($duration / 3600)))

        # Output the formatted HTML row
        echo "  <tr>"
        echo "    <th scope=\"row\">$row_number</th>"
        echo "    <td>$sgs_well</td>"
        echo "    <td>$sgs_date</td>"
        echo "    <td>$p_max</td>"
        echo "    <td>$t_max</td>"
        echo "    <td>$dur_hr</td>"
        echo "    <td>$unit_no</td>"
        # TODO : try to make the link for the direcotry intead of the file itself
        echo "    <td><a href=\"$pdf_path\" target=\"_blank\">link</a></td>"
        echo "  </tr>"

        # Increment the row counter
        ((row_number++))
    done <"$input_file_u1"

    echo "</tbody>"
} >"$output_file_u1"

echo -e "${YELLOW}HTML rows generated in $output_file_u1${NC}"
