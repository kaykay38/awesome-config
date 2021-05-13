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
onedrivelog="$(journalctl --user-unit onedrive  -n 1 | tail -1)"
onedrivestatus="$(echo $onedrivelog | grep -oP '.*\[.*\]: \K\w+')"
if [[ "$onedrivestatus" = '' ]]; then
    echo ""
elif [[ ! -z "$(grep -o 'onedrive.service: Failed' <<< $onedrivelog)" ]]; then
    echo "   ✗  "
elif [[  "$onedrivestatus" = 'Initializing' || "$onedrivestatus" = 'OneDrive' ]] || [[ "$onedrivestatus" = 'onedrive' || "$onedrivestatus" = 'Starting' || "$onedrivestatus" = 'Sync' || "$onedrivestatus" = 'done' || "$onedrivestatus" = 'Internet' ]] || [[ ! -z "$(grep -o ' ... done' <<< $onedrivelog)" ]]; then
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
