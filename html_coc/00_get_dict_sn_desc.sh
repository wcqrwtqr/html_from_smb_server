#!/usr/bin/env bash


# Set the directory to search in (change this to your specific folder)
search_dir="/Users/mohammedalbatati/Downloads/Missing utm/COC/"

# Set the output file
output_file="dict_coc_desc.txt"

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

if [ ! -f "./dict_coc_desc.txt" ]; then
    echo "Error: Input file 'dict_coc_desc.txt' not found." >&2
    exit 1
fi

# Attempt to run the sed command
if ! sed -i '' 's|/Users/mohammedalbatati/Downloads/Missing utm/COC/||g' ./dict_coc_desc.txt; then
    # sed returned a non-zero exit status, indicating an error
    echo "Error: sed failed to modify 'output_coc.html'." >&2
    echo "Possible reasons:" >&2
    echo "  - Insufficient write permissions for the file or directory." >&2
    echo "  - Disk space issues." >&2
    echo "  - Corrupted file." >&2
    exit 1
fi
# '<,'>s/ COC\/.*/"
if ! sed -i '' 's| COC.*|"|g' ./dict_coc_desc.txt; then
    # sed returned a non-zero exit status, indicating an error
    echo "Error: sed failed to modify 'output_coc.html'." >&2
    echo "Possible reasons:" >&2
    echo "  - Insufficient write permissions for the file or directory." >&2
    echo "  - Disk space issues." >&2
    echo "  - Corrupted file." >&2
    exit 1
fi

echo "Results have been saved to $output_file"
