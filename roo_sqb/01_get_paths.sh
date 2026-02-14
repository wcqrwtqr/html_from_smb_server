#!/usr/bin/env bash
source /usr/local/bin/bash_colors.sh

if ! mount | grep -q WL-SL ; then
    echo -e "The mount /Volumes/WL-SL/ not available"
    exit 1
fi 

# Set the directory to search in (change this to your specific folder)
search_dir_2024="/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/SQB/2024/"
search_dir_2025="/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/SQB/2025/"
search_dir_2026="/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/SQB/2026/"
# Search for 2024
output_file_2024="pdf_list_roo_sqb_2024.txt"
if [[ ! -s "$output_file_2024" ]]; then
    echo "2024 file is not available... run script to generate it"
    >"$output_file_2024"
    find "$search_dir_2024" -type f -iname "*.pdf" | while read -r file; do
        file_name=$(basename "$file" .pdf)
        abs_path=$(realpath "$file")
        echo "$file_name,\"$abs_path\"" >>"$output_file_2024"
    done
fi

# Search for 2025
output_file_2025="pdf_list_roo_sqb_2025.txt"
if [[ ! -s "$output_file_2025" ]]; then
    echo "2025 file is not available... run script to generate it"
    >"$output_file_2025"
    find "$search_dir_2025" -type f -iname "*.pdf" | while read -r file; do
        file_name=$(basename "$file" .pdf)
        abs_path=$(realpath "$file")
        echo "$file_name,\"$abs_path\"" >>"$output_file_2025"
    done
fi

# Set the output file
output_file_2026="pdf_list_roo_sqb.txt"

# Clear the output file if it already exists
>"$output_file_2026"
cat "$output_file_2024" "$output_file_2025" >> "$output_file_2026"

# Recursively find all .pdf files and process them
find "$search_dir_2026" -type f -iname "*.pdf" | while read -r file; do
  # Get the file name without the .pdf extension
  file_name=$(basename "$file" .pdf)
  # Get the absolute path of the file
  abs_path=$(realpath "$file")
  # Append the file name and path to the output file
  echo "$file_name,\"$abs_path\"" >>"$output_file_2026"
done

echo -e "${GREEN}Results have been saved to $output_file_2026${NC}"
