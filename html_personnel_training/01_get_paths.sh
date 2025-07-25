#!/usr/bin/env sh

#!/bin/bash

# Set the directory to search in (change this to your specific folder)
# search_dir="/Volumes/WL-SL/02 Slickline/00 Service Quality Pack"
# search_dir="/Volumes/WL-SL/IMS 2024"
# search_dir="/Volumes/WL-SL/Maintenance"
search_dir="/Volumes/HSE/NEOS Personnel Certificate"

# Set the output file
output_file="pdf_list_personnel_training.txt"

# Clear the output file if it already exists
>"$output_file"

# Recursively find all .pdf files and process them
find "$search_dir" -type f -name "*.pdf" | while read -r file; do
  # Get the file name without the .pdf extension
  file_name=$(basename "$file" .pdf)
  # Get the absolute path of the file
  abs_path=$(realpath "$file")
  # Append the file name and path to the output file
  echo "$file_name,\"$abs_path\"" >>"$output_file"
done

echo "Results have been saved to $output_file"
