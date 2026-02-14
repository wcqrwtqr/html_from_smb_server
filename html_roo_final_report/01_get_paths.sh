#!/usr/bin/env bash
source /usr/local/bin/bash_colors.sh

if ! mount | grep -q WL-SL ; then
    echo -e "The mount ${RED}/Volumes/WL-SL/${NC} not available"
    exit 1
fi 

# Set the directory to search in (change this to your specific folder)
search_dir_2024="/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit1/Daily Report/2024/"
search_dir2_2024="/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit2/Daily Report/2024/"
search_dir_2025="/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit1/Daily Report/2025/"
search_dir2_2025="/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit2/Daily Report/2025/"
search_dir_2026="/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit1/Daily Report/2026/"
search_dir2_2026="/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit2/Daily Report/2026/"


# Set the output file for 2024
output_file_2024="pdf_list_roo_final_report_2024.txt"
if [[ ! -s "$output_file_2024" ]]; then
    echo "2024 file is not available... run script to generate it"
    > "$output_file_2024"
    for search_directory in "$search_dir_2024" "$search_dir2_2024"; do
        find "$search_directory" -type f -name "*.pdf" -path "*/Final Report*" -name \
            "*Final*" -not -name "*Slickline*" -not -name "*old*" | \
            while read -r file; do
                file_name=$(basename "$file" .pdf)
                abs_path=$(realpath "$file")
                echo "$file_name,\"$abs_path\"" >>"$output_file_2024"
            done
    done
fi

# Set the output file for 2025
output_file_2025="pdf_list_roo_final_report_2025.txt"
if [[ ! -s "$output_file_2025" ]]; then
    echo "2025 file is not available... run script to generate it"
    > "$output_file_2025"
    for search_directory in "$search_dir_2025" "$search_dir2_2025"; do
        find "$search_directory" -type f -name "*.pdf" -path "*/Final Report*" -name \
            "*Final*" -not -name "*Slickline*" -not -name "*old*" | \
            while read -r file; do
                file_name=$(basename "$file" .pdf)
                abs_path=$(realpath "$file")
                echo "$file_name,\"$abs_path\"" >>"$output_file_2025"
            done
    done
fi

# This is for 2026 only 
output_file_2026="pdf_list_roo_final_report.txt"

# Clear the output file if it already exists
>"$output_file_2026"
cat "$output_file_2024" "$output_file_2025" >> "$output_file_2026"

# for 2026
# Recursively find all .pdf files and process them from both directories
for search_directory in "$search_dir_2026" "$search_dir2_2026"; do
  find "$search_directory" -type f -name "*.pdf" -path "*/Final Report*" -name \
      "*Final*" -not -name "*Slickline*" -not -name "*old*" | \
      while read -r file; do
    # Get the file name without the .pdf extension
    file_name=$(basename "$file" .pdf)
    # Get the absolute path of the file
    abs_path=$(realpath "$file")
    # Append the file name and path to the output file
    echo "$file_name,\"$abs_path\"" >>"$output_file_2026"
  done
done

echo -e "${MAGENTA}Results have been saved to $output_file${NC}"
