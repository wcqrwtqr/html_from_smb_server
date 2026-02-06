#!/usr/bin/env bash

# What is the code doing while this lag
# Set the directory to search in (change this to your specific folder)

if ! mount | grep -q WL-SL ; then
    echo "The mount /Volumes/WL-SL/ not available"
    exit 1
fi 

search_dir_u1="/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit1/Daily Report/"
search_dir_u2="/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit2/Daily Report/"
# search_dir_u2="/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit1/Daily Report/"

# Set the output file
output_file_u1="pdf_list_sgs_results_u1.txt"
# output_file2="pdf_list_sgs_results_u2.txt"

# Clear the output file if it already exists
>"$output_file_u1"

# Find command that will go throw the directory and get all the files from the sgs results
# with .txt extension and will read it using awk and printout max press, max temp, count and
# the file name to be catted out to the file output_file
find "$search_dir_u1" -name "*_Top_*" -name "*.txt" -type f -exec awk '
  NR>=30 {if($4>maxt) maxt=$4; if($3>maxp) maxp=$3}
  END { if(maxt!=0 || maxp!=0) printf "%.1f,%.1f,%d,%s,Unit-1\n", maxp+0, maxt+0, NR, FILENAME;}
' {} \; > "$output_file_u1"
echo "Results for unit-1 have been saved to $output_file_u1"

find "$search_dir_u2" -name "*_Top_*" -name "*.txt" -type f -exec awk '
  NR>=30 {if($4>maxt) maxt=$4; if($3>maxp) maxp=$3}
  END { if(maxt!=0 || maxp!=0) printf "%.1f,%.1f,%d,%s,Unit-2\n", maxp+0, maxt+0, NR, FILENAME;}
' {} \; >> "$output_file_u1"
echo "Results have been saved to $output_file_u1"
