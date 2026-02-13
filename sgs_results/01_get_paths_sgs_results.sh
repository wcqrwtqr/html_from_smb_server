#!/usr/bin/env bash
source /usr/local/bin/bash_colors.sh

# What is the code doing while this lag
# Set the directory to search in (change this to your specific folder)

if ! mount | grep -q WL-SL ; then
    echo -e "${RED}The mount /Volumes/WL-SL/ not available${NC}"
    exit 1
fi 

output_file_2024="pdf_list_sgs_results_2024.txt"
output_file_2025="pdf_list_sgs_results_2025.txt"
search_dir_u12024="/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit1/Daily Report/2024/"
search_dir_u22024="/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit2/Daily Report/2024/"
search_dir_u12025="/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit1/Daily Report/2025/"
search_dir_u22025="/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit2/Daily Report/2025/"
search_dir_u12026="/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit1/Daily Report/2026/"
search_dir_u22026="/Volumes/WL-SL/02 Slickline/01 Jobs/BECL BP/Unit2/Daily Report/2026/"

# These files will be resued as we don't need to loop over them every time
if [[ ! -s "$output_file_2024" ]]; then
    echo "2024 file is not available... run script to generate it"
    >"$output_file_2024"
    find "$search_dir_u12024" -name "*_Top_*" -name "*.txt" -type f -exec awk '
  NR>=30 {if($4>maxt) maxt=$4; if($3>maxp) maxp=$3}
  END { if(maxt!=0 || maxp!=0) printf "%.1f,%.1f,%d,%s,Unit-1\n", maxp+0, maxt+0, NR, FILENAME;}
' {} \; > "$output_file_2024"
    find "$search_dir_u22024" -name "*_Top_*" -name "*.txt" -type f -exec awk '
  NR>=30 {if($4>maxt) maxt=$4; if($3>maxp) maxp=$3}
  END { if(maxt!=0 || maxp!=0) printf "%.1f,%.1f,%d,%s,Unit-2\n", maxp+0, maxt+0, NR, FILENAME;}
' {} \; >> "$output_file_2024"
    echo "Done generating 2024 SGS results"
fi 
# Check for 2025 data 
if [[ ! -s "$output_file_2025" ]]; then
    echo "2025 file is not available... run script to generate it"
    >"$output_file_2025"
    find "$search_dir_u12025" -name "*_Top_*" -name "*.txt" -type f -exec awk '
  NR>=30 {if($4>maxt) maxt=$4; if($3>maxp) maxp=$3}
  END { if(maxt!=0 || maxp!=0) printf "%.1f,%.1f,%d,%s,Unit-1\n", maxp+0, maxt+0, NR, FILENAME;}
' {} \; > "$output_file_2025"
    find "$search_dir_u22025" -name "*_Top_*" -name "*.txt" -type f -exec awk '
  NR>=30 {if($4>maxt) maxt=$4; if($3>maxp) maxp=$3}
  END { if(maxt!=0 || maxp!=0) printf "%.1f,%.1f,%d,%s,Unit-2\n", maxp+0, maxt+0, NR, FILENAME;}
' {} \; >> "$output_file_2025"
    echo "Done generating 2024 SGS results"
fi 

# Above code is for 2024 and 2025, no need to run it again 


# Set the output file
output_file_2026="pdf_list_sgs_results_2026.txt"

# Clear the output file if it already exists
>"$output_file_2026"
cat "$output_file_2024" "$output_file_2025" >> "$output_file_2026"

# Find command that will go throw the directory and get all the files from the
# sgs results
find "$search_dir_u12026" -name "*_Top_*" -name "*.txt" -type f -exec awk '
  NR>=30 {if($4>maxt) maxt=$4; if($3>maxp) maxp=$3}
  END { if(maxt!=0 || maxp!=0) printf "%.1f,%.1f,%d,%s,Unit-1\n", maxp+0, maxt+0, NR, FILENAME;}
' {} \; >> "$output_file_2026"
echo -e "${YELLOW}Results for both units have been saved to $output_file_2026${NC}"

find "$search_dir_u22026" -name "*_Top_*" -name "*.txt" -type f -exec awk '
  NR>=30 {if($4>maxt) maxt=$4; if($3>maxp) maxp=$3}
  END { if(maxt!=0 || maxp!=0) printf "%.1f,%.1f,%d,%s,Unit-2\n", maxp+0, maxt+0, NR, FILENAME;}
' {} \; >> "$output_file_2026"

echo -e "${YELLOW}Results have been saved to $output_file_2026${NC}"
