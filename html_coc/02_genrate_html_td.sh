#!/usr/bin/env bash
source /usr/local/bin/bash_colors.sh


# Define the input file and output HTML file
input_file="pdf_list_coc.txt" #pdf_list_roo_coc.txt
output_file="output_coc.html"

# Load the dict for the nov COC
declare -A sn_dict

# Check if the input file exists before attempting to modify it
if [ ! -f "./dict_coc_desc.txt" ]; then
    echo "Error: Input file 'dict_coc_desc.txt' not found." >&2
    exit 1
fi

while IFS=',' read -r key value; do
  # Trim quotes and whitespace from key and value
  key="${key#\"}"
  key="${key%\"}"
  value="${value#\"}"
  value="${value%\"}"
  
  sn_dict["$key"]="$value"
done < ./dict_coc_desc.txt


# Initialize the row counter
row_number=1

# Open the output file for writing
{
  echo "<tbody>"

  # Loop through each line in the input file
  while IFS=, read -r pdf_name pdf_path; do
    # if [[ "$pdf_name" != *"SQB"* ]]; then
    #   continue # Skip this line if "SQB" is not in pdf_name
    # fi
    # Remove surrounding quotes from the pdf_path
    pdf_path=$(echo "$pdf_path" | tr -d '"')
    sn=$(echo "$pdf_name" | cut -c 1-$((${#pdf_name}-4)))

    # Output the formatted HTML row
    echo "  <tr>"
    echo "    <th scope=\"row\">$row_number</th>"
    echo "    <td>${sn_dict["$pdf_name"]}</td>"
    echo "    <td>$sn</td>"
    echo "    <td>COC</td>"
    echo "    <td><a href=\"$pdf_path\" target=\"_blank\">link</a></td>"
    echo "  </tr>"

    # Increment the row counter
    ((row_number++))
  done <"$input_file"

  echo "</tbody>"
} >"$output_file"

echo -e "${GREEN}HTML rows generated in $output_file${NC}"
