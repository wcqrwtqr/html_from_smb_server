#!/usr/bin/env bash

# What is the code doing while this lag
# Set the directory to search in (change this to your specific folder)
# search_dir="/Volumes/WL-SL/IMS 2024"
search_dir="/Volumes/WL-SL/02 Slickline/.Personnel/"

# Set the output file
output_file="pdf_list_personnel.txt"

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

echo "Results have been saved to $output_file"
