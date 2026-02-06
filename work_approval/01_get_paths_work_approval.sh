#!/usr/bin/env bash
source /usr/local/bin/bash_colors.sh

if ! mount | grep -q WL-SL ; then
    echo -e "The mount /Volumes/WL-SL/ not available"
    exit 1
fi 

# What is the code doing while this lag
search_dir="/Volumes/WL-SL/05 WORK APPROVAL/موافقة عمل/BECL/"

# Set the output file
output_file="pdf_list_work_approval.txt"

# Clear the output file if it already exists
>"$output_file"

# Build the find command with dynamic exclusions
# find_cmd="find \"$search_dir\" -type f -name \"[0-9][0-9][0-9][0-9]*\" -not -path \"*/EXPIRED/*\""
find_cmd="find \"$search_dir\" -type f -name \"EXP*\" -not -path \"*/EXPIRED/*\""
# for dir in $excluded_dirs; do
#   find_cmd="$find_cmd -not -path \"*/$dir/*\""
# done

# Recursively find all .pdf files and process them
eval "$find_cmd" | while read -r file; do
  # Get the file name without the .pdf extension
  file_name=$(basename "$file" .pdf)

  # Get the absolute path of the file
  abs_path=$(realpath "$file")
  # Append the file name and path to the output file
  echo "$file_name,\"$abs_path\"" >>"$output_file"
done

echo -e "${GREEN}Results have been saved to $output_file${NC}"
