#!/usr/bin/env bash
source /usr/local/bin/bash_colors.sh

# Check if the input file exists before attempting to modify it
if [ ! -f "./output_form_wl-sl.html" ]; then
    echo -e "${RED}Error: Input file output_form_wl-sl.html not found.${NC}" >&2
    exit 1
fi

# Attempt to run the sed command
if ! sed -i '' 's|/Volumes/WL-SL|..|g' ./output_form_wl-sl.html ;then
    # sed returned a non-zero exit status, indicating an error
    echo -e "Error: sed failed to modify ${RED}./output_form_wl-sl.html${NC}'." >&2
    echo "Possible reasons:" >&2
    echo "  - Insufficient write permissions for the file or directory." >&2
    echo "  - Disk space issues." >&2
    echo "  - Corrupted file." >&2
    exit 1
fi

# If sed was successful, the script continues here
echo -e "${YELLOW}File 'output_form_wl-sl.html' processed successfully.${NC}"
