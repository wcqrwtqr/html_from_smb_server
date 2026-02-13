#!/usr/bin/env bash
source /usr/local/bin/bash_colors.sh

# Date: 20260213
# This code is to rsync the folder of SL-WL from the IMS folder
# to the WL-SL server rsync

# Check if the mnt IMS and WL-SL
if ! mount | grep -q IMS ; then
  echo "Error: ${RED}/Volumes/IMS${NC} is not mounted. Exiting." >&2
  exit 1
fi
echo "IMS volume available, continuing..."
if ! mount | grep -q WL-SL ; then
  echo "Error: /Volumes/WL-SL/ is not mounted. Exiting." >&2
  exit 1
fi
echo "WL-SL volume available, continuing..."

# Start the rsync
echo -e "${YELLOW}Start rsync NEOS Form WL-SL..${NC}"

rsync -azr --delete "/Volumes/IMS/New Hand Over Folder with Aligenment/01- NEOS IMS Final-2025-Uploaded on Server 20-Oct-25/Level- 4 - Form & Templates/SL-WL/pdf-forms/" \
    "/Volumes/WL-SL/02 Slickline/.dot-files/form_wl-sl/"

echo -e "${YELLOW}Finished rsync WL-SL forms's${NC}"
