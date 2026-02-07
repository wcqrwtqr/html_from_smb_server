#!/usr/bin/env bash
source /usr/local/bin/bash_colors.sh

if ! mount | grep -q WL-SL ; then
    echo -e "The mount /Volumes/WL-SL/ not available"
    exit 1
fi 

# Set the directory to search in (change this to your specific folder)
search_dir="/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/SQB/"
# search_dir="/Volumes/WL-SL/IMS 2024"

# Set the output file
output_file="pdf_list_roo_sqb.txt"
# output_file="pdf_list_oem.txt"

# Clear the output file if it already exists
>"$output_file"

# Recursively find all .pdf files and process them
find "$search_dir" -type f -iname "*.pdf" | while read -r file; do
  # Get the file name without the .pdf extension
  file_name=$(basename "$file" .pdf)
  # Get the absolute path of the file
  abs_path=$(realpath "$file")
  # Append the file name and path to the output file
  echo "$file_name,\"$abs_path\"" >>"$output_file"
done

echo -e "${GREEN}Results have been saved to $output_file${NC}"
