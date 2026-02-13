#!/usr/bin/env bash
source /usr/local/bin/bash_colors.sh

# Define the input file and output HTML file
input_file="pdf_list_form_qhse.txt"
output_file="output_form_qhse.html"

if [[ ! -f "$input_file" ]] ; then
    echo -e "The file ${RED}pdf_list_form_qhse.txt generated from ./01_get_paths_form_qhse.sh${NC} was not ran"
    exit 1
fi

# Initialize the row counter
row_number=1

# Open the output file for writing
{
  echo "<tbody>"

  # Loop through each line in the input file
  while IFS=: read -r pdf_name pdf_path; do
    # Remove surrounding quotes from the pdf_path
    if [[ "$pdf_name" = *"Expired"* ]]; then
      continue # Skip this line if "SQB" is not in pdf_name
    fi
    # Delete the " from the path 
    pdf_path=$(echo "$pdf_path" | tr -d '"')

    rev_no=$(echo "$pdf_name" | grep -o "Rev \d\d")
    # cert_type=$(echo "$pdf_name" | awk '{print $3}')

    # Output the formatted HTML row
    echo "  <tr>"
    echo "    <th scope=\"row\">$row_number</th>"
    echo "    <td>$pdf_name</td>"
    echo "    <td>Form</td>"
    echo "    <td>$rev_no</td>"
    echo "    <td><a href=\"$pdf_path\" target=\"_blank\">link</a></td>"
    echo "  </tr>"

    # Increment the row counter
    ((row_number++))
  done <"$input_file"

  echo "</tbody>"
} >"$output_file"

echo -e "${YELLOW}HTML rows generated in $output_file${NC}"
