#!/bin/bash

# Define the input file and output HTML file
input_file="pdf_list_truck_maintenance.txt"
output_file="output_trucks_maintenace.html"

# Initialize the row counter
row_number=1

# Open the output file for writing
{
  echo "<tbody>"

  # Loop through each line in the input file
  while IFS=, read -r pdf_name pdf_path; do
    # Remove surrounding quotes from the pdf_path
    # pdf_path=$(echo "$pdf_path" | tr -d '"')
    pdf_path=$(echo "$pdf_path" | tr -d '"' | tr -d '\n')

    # Extract the year (assumed to be a 4-digit number) from the pdf_path
    # year=$(echo "$pdf_path" | grep -oE '[0-9]{4}')
    # Extract the year from either the pdf_name or pdf_path
    # year=$(echo "$pdf_name" | grep -oE '[0-9]{4}' || echo "$pdf_path" | grep -oE '[0-9]{4}')
    year=$(echo "$pdf_name" | grep -oE '[0-9]{4}' | tr -d '\n' | cut -c 1-4)
    month=$(echo "$pdf_name" | grep -oE '[0-9]{4}' | tr -d '\n' | cut -c 5-6)

    # Output the formatted HTML row
    echo "  <tr>"
    echo "    <th scope=\"row\">$row_number</th>"
    echo "    <td>$pdf_name</td>"
    echo "    <td>$month</td>"
    echo "    <td>$year</td>"
    echo "    <td>Maintenance Checklist</td>"
    echo "    <td><a href=\"$pdf_path\" target=\"_blank\">link</a></td>"
    echo "  </tr>"

    # Increment the row counter
    ((row_number++))
  done <"$input_file"

  echo "</tbody>"
} >"$output_file"

echo "HTML rows generated in $output_file"
