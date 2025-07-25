#!/bin/bash

# Define the input file and output HTML file
input_file="pdf_list_roo_final_report.txt" #pdf_list_roo_final_report.txt
output_file="output_roo_final_report.html"

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
    # Extract year and month and date
    year=$(echo "$pdf_name" | grep -oE '[0-9]{8}' | cut -c 1-4)
    month=$(echo "$pdf_name" | grep -oE '[0-9]{8}' | cut -c 5-6)
    thedate=$(echo "$pdf_name" | grep -oE '[0-9]{8}' | cut -c 7-8)

    # Output the formatted HTML row
    echo "  <tr>"
    echo "    <th scope=\"row\">$row_number</th>"
    echo "    <td>$pdf_name</td>"
    echo "    <td>$year-$month-$thedate</td>"
    echo "    <td>Final Report</td>"
    echo "    <td><a href=\"$pdf_path\" target=\"_blank\">link</a></td>"
    echo "  </tr>"

    # Increment the row counter
    ((row_number++))
  done <"$input_file"

  echo "</tbody>"
} >"$output_file"

echo "HTML rows generated in $output_file"
