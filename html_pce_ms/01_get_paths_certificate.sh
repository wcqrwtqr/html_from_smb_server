#!/usr/bin/env bash

# What is the code doing while this lag
# Set the directory to search in (change this to your specific folder)
# search_dir="/Volumes/WL-SL/IMS 2024"
search_dir="/Volumes/WL-SL/02 Slickline/02 Maintenance/PCE/"

# Set the output file
output_file="pdf_list_certificate.txt"

# Configure exclusions
# Directories to exclude (space-separated list)
# excluded_dirs="IMS FAILURE_REPORT_MAINTENANCE EXPIRED wirelog 44388-01 44388-02 BACKUP Software zz-Form zapp Wire POST_JOB_MTC_REPORT_SL_TOOL_PLUG_EQUIPMENT_2025"
# Words to exclude from filenames (pipe-separated for grep)
# excluded_words="IMS|repair|backup|test|draft|test|logbook|purtitystickstoff_en|Software|test|test2|LogBook"

# Clear the output file if it already exists
>"$output_file"

# Build the find command with dynamic exclusions
find_cmd="find \"$search_dir\" -type f -name \"[0-9][0-9][0-9][0-9]*\" -not -path \"*/EXPIRED/*\""
# for dir in $excluded_dirs; do
#   find_cmd="$find_cmd -not -path \"*/$dir/*\""
# done

# Recursively find all .pdf files and process them
eval "$find_cmd" | while read -r file; do
  # Get the file name without the .pdf extension
  file_name=$(basename "$file" .pdf)

  # Skip files that contain excluded words (case-insensitive)
  # if echo "$file_name" | grep -qi "$excluded_words"; then
  #   echo "Skipping: $file_name (contains excluded word)"
  #   continue
  # fi

  # Get the absolute path of the file
  abs_path=$(realpath "$file")
  # Append the file name and path to the output file
  echo "$file_name,\"$abs_path\"" >>"$output_file"
done

echo "Results have been saved to $output_file"
