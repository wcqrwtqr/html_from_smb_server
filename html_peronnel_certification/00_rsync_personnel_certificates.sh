#!/usr/bin/env bash

source /usr/local/bin/bash_colors.sh

# Date: 2026-02-04
# This code is to rsync the folder of the personnel certificaiton from the
# HSE folder to the WL-SL rsync

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
echo -e "${YELLOW}Start rsync personnel certificaiton..${NC}"

rsync -azr --delete "/Volumes/HSE/8-NEOS Personnel Certificate SL-TRS/20260204 Wireline and Slickline Personnels/" \
    "/Volumes/WL-SL/02 Slickline/.Personnel/"

echo -e "${YELLOW}Finished rsync personnel certificaiton${NC}"
