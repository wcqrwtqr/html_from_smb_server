#!/usr/bin/env bash
source /usr/local/bin/bash_colors.sh

# Date: 20260208
# Extract the ROO SOP from the folder .IMS/ROO SOP and generate the
# txt file to be converted to html
# 
# Set the directory to search in (change this to your specific folder)
if [[ ! -d "/Volumes/WL-SL/02 Slickline/.IMS/" ]]; then
    echo -e "${RED}The folder .IMS is not available${NC}"
    exit 1
fi
search_dir="/Volumes/WL-SL/02 Slickline/.IMS/ROO SLS SOP/"

# Set the output file
output_file="pdf_list_roo_sop.txt"

# Clear the output file if it already exists
>"$output_file"

# Build the find command with dynamic exclusions
find_cmd="find \"$search_dir\" -type f -iname \"*.pdf\" -not -ipath \"*Obsolete*\"" 

# Recursively find all .pdf files and process them
eval "$find_cmd" | while read -r file; do
  # Get the file name without the .pdf extension
  file_name=$(basename "$file" .pdf)

  # Get the absolute path of the file
  abs_path=$(realpath "$file")
  # Append the file name and path to the output file
  echo "$file_name:\"$abs_path\"" >>"$output_file"
done

echo -e "${YELLOW}Results have been saved to $output_file${NC}"
