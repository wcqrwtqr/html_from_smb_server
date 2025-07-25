#!/bin/bash

# Define the input file and output HTML file
input_file="pdf_list_certificate.txt"
output_file="output_certificate.html"

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

    # year=$(echo "$pdf_name" | grep -oE '[0-9]{4}' | tr -d '\n' | cut -c 1-4)
    # month=$(echo "$pdf_name" | grep -oE '[0-9]{4}' | tr -d '\n' | cut -c 5-6)

    # Output the formatted HTML row
    echo "  <tr>"
    echo "    <th scope=\"row\">$row_number</th>"
    echo "    <td>$pdf_name</td>"
    # echo "    <td>$month</td>"
    # echo "    <td>$year</td>"
    echo "    <td>Certificate</td>"
    echo "    <td><a href=\"$pdf_path\" target=\"_blank\">link</a></td>"
    echo "  </tr>"

    # Increment the row counter
    ((row_number++))
  done <"$input_file"

  echo "</tbody>"
} >"$output_file"

echo "HTML rows generated in $output_file"
