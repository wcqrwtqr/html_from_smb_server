#!/usr/bin/env bash
source /usr/local/bin/bash_colors.sh

# Define the input file and output HTML file
input_file="pdf_list_work_approval.txt"
output_file="output_work_approval.html"

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
    if [[ "$pdf_name" = *"Expired"* ]]; then
      continue # Skip this line if "SQB" is not in pdf_name
    fi
    # Delete the " from the path 
    pdf_path=$(echo "$pdf_path" | tr -d '"')
    # Split the $2 and $3 which si the exp date, and certifiate type
    exp_date=$(echo "$pdf_name" | awk '{print $2}')
    work_field=$(echo "$pdf_name" | awk '{print $3 " " $4}')
    work_time=$(echo "$pdf_name" | awk '{print $5}')

    if [[ -z "$exp_date" ]]; then
        continue
    fi 

    exp_epoch=$(date -j -f "%Y%m%d" "$exp_date" "+%s")
    today_epoch=$(date "+%s")
    next_month_epoch=$(date -v+30d "+%s")

    # Output the formatted HTML row
    echo "  <tr>"
    echo "    <th scope=\"row\">$row_number</th>"
        if (( exp_epoch < today_epoch )); then
        echo "    <td class="text-bg-danger">$pdf_name</td>"
    elif (( exp_epoch <= next_month_epoch )); then
        echo "    <td class="text-bg-warning">$pdf_name</td>"
    else
        echo "    <td>$pdf_name</td>"
    fi
    echo "    <td>$work_field</td>"
    echo "    <td>$work_time</td>"
    echo "    <td>$exp_date</td>"
    echo "    <td><a href=\"$pdf_path\" target=\"_blank\">link</a></td>"
    echo "  </tr>"

    # Increment the row counter
    ((row_number++))
  done <"$input_file"

  echo "</tbody>"
} >"$output_file"

echo -e "${GREEN}HTML rows generated in $output_file${NC}"
