#!/bin/bash

# Define the input file and output HTML file
input_file="pdf_list_personnel_training.txt"
output_file="output_personnel_training.html"

# Initialize the row counter
row_number=1

# Open the output file for writing
{
  echo "<tbody>"

  # Loop through each line in the input file
  while IFS=, read -r pdf_name pdf_path; do
    # Remove surrounding quotes from the pdf_path
    pdf_path=$(echo "$pdf_path" | tr -d '"')
    name=$(echo "$pdf_name" | cut -d'_' -f1)
    training_course=$(echo "$pdf_name" | cut -d'_' -f2)
    year=$(echo "$pdf_name" | grep -oE '[0-9]{6}' | cut -c 1-4)
    month=$(echo "$pdf_name" | grep -oE '[0-9]{6}' | cut -c 5-6)
    # thedate=$(echo "$pdf_name" | grep -oE '^[0-9]{6}' | cut -c 7-8)

    # Output the formatted HTML row
    echo "  <tr>"
    echo "    <th scope=\"row\">$row_number</th>"
    # echo "    <td>$pdf_name</td>"
    echo "    <td>$name</td>"
    # echo "    <td>$training_course</td>"
    echo "    <td>$year-$month</td>"
    echo "    <td>$training_course</td>"
    echo "    <td><a href=\"$pdf_path\" target=\"_blank\">link</a></td>"
    echo "  </tr>"

    # Increment the row counter
    ((row_number++))
  done <"$input_file"

  echo "</tbody>"
} >"$output_file"

echo "HTML rows generated in $output_file"
