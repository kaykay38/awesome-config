#!/bin/sh
#---------------------------------------------------------------------------
# OneDrive Status Script
#
# Depends: systemd, onedrive
#
#
# @author kaykay38
# @copyright 2021 kaykay38
#---------------------------------------------------------------------------
onedrivelog="$(journalctl --user-unit onedrive  -n 1)"
onedrivestatus="$(echo $onedrivelog | grep -oP 'onedrive\[.*\]: \K\w+')"
if [[ "$onedrivestatus" = '' ]]; then
    echo ""
elif [[  "$onedrivestatus" = 'Initializing' || "$onedrivestatus" = 'OneDrive' || "$onedrivestatus" = 'Starting' || "$onedrivestatus" = 'Sync' || "$onedrivestatus" = 'done' || "$onedrivestatus" = 'Internet' ]] || [[ ! -z "$(echo $onedrivelog | grep -o ' ... done')" ]]; then
    echo "    "
elif [[ "$onedrivestatus" = 'Downloading' ]]; then
    echo "     "
elif [[ "$onedrivestatus" = 'Uploading' ]]; then
    echo "     "
elif [[  "$onedrivestatus" = 'Creating' || "$onedrivestatus" = 'Deleting' || "$onedrivestatus" = 'Syncing' || "$onedrivestatus" = 'Moving' ]]; then
    echo "     "
else
    echo "   ✗  "
fi
