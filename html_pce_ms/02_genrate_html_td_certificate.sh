#!/usr/bin/env bash
source /usr/local/bin/bash_colors.sh

# Define the input file and output HTML file
input_file="pdf_list_certificate.txt"
output_file="output_certificate.html"

if [[ ! -f "$input_file" ]]; then
    echo -e "${RED}The $input_file is not available${NC}"
    exit 1
fi


# Initialize the row counter
row_number=1

# Open the output file for writing
{
  echo "<tbody>"

  # Loop through each line in the input file
  while IFS=, read -r pdf_name pdf_path; do
    # Remove surrounding quotes from the pdf_path
    # pdf_path=$(echo "$pdf_path" | tr -d '"')
    # pdf_path=$(echo "$pdf_path" | tr -d '"' | tr -d '\n')
    if [[ "$pdf_name" = *"Expired"* ]]; then
      continue # Skip this line if "SQB" is not in pdf_name
    fi
    pdf_path=$(echo "$pdf_path" | tr -d '"')

    # Output the formatted HTML row
    echo "  <tr>"
    echo "    <th scope=\"row\">$row_number</th>"
    echo "    <td>$pdf_name</td>"
    echo "    <td>Maintenance</td>"
    echo "    <td><a href=\"$pdf_path\" target=\"_blank\">link</a></td>"
    echo "  </tr>"

    # Increment the row counter
    ((row_number++))
  done <"$input_file"

  echo "</tbody>"
} >"$output_file"

echo -e "${GREEN}HTML rows generated in $output_file${NC}"
