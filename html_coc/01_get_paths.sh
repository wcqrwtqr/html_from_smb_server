#!/usr/bin/env bash


# Set the directory to search in (change this to your specific folder)
search_dir="/Volumes/WL-SL/02 Slickline/05 OEM Quality Book/.COC/"
# search_dir="/Users/mohammedalbatati/Downloads/Missing utm/COC/"

# Set the output file
output_file="pdf_list_coc.txt"

# Clear the output file if it already exists
>"$output_file"

# Recursively find all .pdf files and process them from both directories
for search_directory in "$search_dir"; do
  find "$search_directory" -type f -name "*.pdf" -name "*CC1*" | while read -r file; do
    # Get the file name without the .pdf extension
    file_name=$(basename "$file" .pdf)
    # Get the absolute path of the file
    abs_path=$(realpath "$file")
    # Append the file name and path to the output file
    echo "$file_name,\"$abs_path\"" >>"$output_file"
  done
done

echo "Results have been saved to $output_file"
