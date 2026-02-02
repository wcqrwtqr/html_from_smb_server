#!/usr/bin/env python3

import os
import subprocess
import re

def main():
    search_dir = "/Volumes/WL-SL/02 Slickline/02 Maintenance"
    output_file = "pdf_list_certificate_python.txt"
    excluded_dirs = "IMS FAILURE_REPORT_MAINTENANCE EXPIRED wirelog 44388-01 44388-02 BACKUP Software zz-Form zapp Wire POST_JOB_MTC_REPORT_SL_TOOL_PLUG_EQUIPMENT_2025".split()
    excluded_words = r"IMS|repair|backup|draft|logbook|purtitystickstoff_en|Software|LogBook"  # Raw string for regex

    # Clear the output file
    try:
        with open(output_file, "w") as f:
            pass  # Just open in write mode to clear
    except Exception as e:
        print(f"Error clearing output file: {e}")
        return


    # Walk through the directory tree
    for root, dirs, files in os.walk(search_dir):
        # Skip excluded directories
        dirs[:] = [d for d in dirs if d not in excluded_dirs]  # Modify dirs in-place to prune traversal


        for file in files:
            if file.endswith(".pdf"):
                file_name = file[:-4]  # Remove ".pdf" extension
                if re.search(excluded_words, file_name, re.IGNORECASE):
                    print(f"Skipping: {file_name} (contains excluded word)")
                    continue

                abs_path = os.path.abspath(os.path.join(root, file))
                try:
                    with open(output_file, "a") as f:
                        f.write(f'"{file_name}","{abs_path}"\n')
                except Exception as e:
                    print(f"Error writing to output file: {e}")
                    return

    print(f"Results have been saved to {output_file}")


if __name__ == "__main__":
    main()
