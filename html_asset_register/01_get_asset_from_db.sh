#!/usr/bin/env bash
source /usr/local/bin/bash_colors.sh

set -euo pipefail

# This code used to read the database ~/org/Exported_database_2026_noes.csv
# and if it is not available then it will generate it

input_file="$HOME/org/Exported_database_2026_noes.csv"
output_file="assets_table.html"
if [[ ! -f "$HOME/org/Exported_database_2026_noes.csv" ]]; then
    echo -e "${RED}The databse file is not available... Creating a new one${NC}" &&
        sqlite3 -header -csv $HOME/org/neosdatabase.db "SELECT * FROM sl_equipment;" > $HOME/org/Exported_database_2026_noes.csv
fi
row_number=1

{
  echo "<tbody>"

  # Skip header, process data rows only
  tail -n +2 "$input_file" | while IFS=',' read -r id sn description type size tag manufacturer comment bl inOperation category isAsset rating; do
    # Remove surrounding quotes from description
    description=$(echo "$description" | tr -d '"')
    
    echo "  <tr>"
    echo "    <th scope=\"row\">$row_number</th>"
    echo "    <td>$description</td>"
    echo "    <td>$sn</td>"
    echo "    <td>$type</td>"
    echo "    <td>$size</td>"
    echo "    <td>$tag</td>"
    echo "    <td>$manufacturer</td>"
    # echo "    <td>$comment</td>"
    echo "    <td>$bl</td>"
    if [[ $inOperation -eq 1 ]]; then
        echo "    <td>Yes</td>"
    else
        echo "    <td>No</td>"
    fi
    # echo "    <td>$inOperation</td>"
    echo "    <td>$category</td>"
    # if [[ $isAsset -eq 1 ]]; then
    #     echo "    <td>Yes</td>"
    # else
    #     echo "    <td>No</td>"
    # fi
    # echo "    <td>$isAsset</td>"
    echo "    <td>$rating</td>"
    echo "  </tr>"

    ((row_number++))
  done

  echo "</tbody>"
} > "$output_file"


       
# What is the code doing while this lag
search_dir="/Volumes/WL-SL/02 Slickline/02 Maintenance/PCE/"

# Set the output file
output_file="pdf_list_certificate.txt"


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

echo -e "${MAGENTA}Results have been saved to $output_file${NC}"
