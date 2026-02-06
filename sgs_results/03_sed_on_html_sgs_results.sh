#!/usr/bin/env bash

sed_file="output_sgs_results_u1.html"

# Check if the input file exists before attempting to modify it
if [ ! -f "$sed_file" ]; then
    echo "Error: Input file 'output_roo_final_report.html' not found." >&2
    exit 1
fi

# Attempt to run the sed command
if ! sed -i '' 's|/Volumes/WL-SL|..|g' "$sed_file"; then
    # sed returned a non-zero exit status, indicating an error
    echo "Error: sed failed to modify '$sed_file'." >&2
    echo "Possible reasons:" >&2
    echo "  - Insufficient write permissions for the file or directory." >&2
    echo "  - Disk space issues." >&2
    echo "  - Corrupted file." >&2
    exit 1
fi

# If sed was successful, the script continues here
echo "File 'output_sgs_results_u1.html' processed successfully."
