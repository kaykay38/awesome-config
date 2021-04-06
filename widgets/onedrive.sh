#!/bin/sh
#---------------------------------------------------------------------------
# OneDrive Status Script
#
# Depends: systemd, onedrive
#
#
# @author kaykay38
# @copyright 2020 kaykay38
#---------------------------------------------------------------------------

onedrivestatus="$(journalctl --user-unit onedrive  -n 5 | tail -n 1 | grep -oP 'onedrive\[.*\]: \K\w+')"
if [[ "$onedrivestatus" = '' ]]; then
    echo ""
elif [[ "$onedrivestatus" = 'Downloading' ]]; then
    echo "     "
elif [[ "$onedrivestatus" = 'Uploading' ]]; then
    echo "     "
elif [[  "$onedrivestatus" = 'Creating' || "$onedrivestatus" = 'Deleting' || "$onedrivestatus" = 'Syncing' || "$onedrivestatus" = 'Moving' ]]; then
    echo "     "
elif [[  "$status" = 'Initializing' || "$status" = 'OneDrive' || "$status" = 'Sync' ]]; then
    echo "    "
else
    echo "   ✗  "
fi
