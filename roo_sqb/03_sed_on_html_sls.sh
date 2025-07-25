#!/bin/bash

# sed -i '' 's|/Volumes/WL-SL|..|g' ./output_roo_sqb.html

# Check if the input file exists before attempting to modify it
if [ ! -f "./output_roo_sqb.html" ]; then
    echo "Error: Input file './output_roo_sqb.html' not found." >&2
    exit 1
fi

# Attempt to run the sed command
if ! sed -i '' 's|/Volumes/WL-SL|..|g' ./output_roo_sqb.html; then
    # sed returned a non-zero exit status, indicating an error
    echo "Error: sed failed to modify './output_roo_sqb.html'." >&2
    echo "Possible reasons:" >&2
    echo "  - Insufficient write permissions for the file or directory." >&2
    echo "  - Disk space issues." >&2
    echo "  - Corrupted file." >&2
    exit 1
fi

# If sed was successful, the script continues here
echo "File './output_roo_sqb.html' processed successfully."
