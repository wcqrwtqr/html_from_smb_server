#!/bin/bash

# Step 1: Extract the entire <tbody>...</tbody> block from source.html into a temporary file
sed -n '/<tbody>/,/<\/tbody>/p' ./output_ims.html >tbody_content.txt

# Step 2: Replace the <tbody>...</tbody> block in target.html with the content from tbody_content.txt
# sed -i.bak '/<tbody>/,/<\/tbody>/{
#     r tbody_content.txt
#     d
# }' test.html

sed -i.bak '0,/<tbody>/{
    /<tbody>/{
        r tbody_content.txt
        d
    }
}' test.html

# Cleanup
rm tbody_content.txt

#Explanation:
# 1. `sed -n '/<tbody>/,/<\/tbody>/p' source.html` extracts everything between <tbody> and </tbody> in source.html.
# 2. `sed -i.bak '/<tbody>/,/<\/tbody>/c\'"$tbody_content" target.html` replaces the <tbody>...</tbody> section in target.html with the content from source.html.
#    - The `-i.bak` option creates a backup of the original target file (optional).
