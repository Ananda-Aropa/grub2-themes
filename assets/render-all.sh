#!/bin/bash

THEMES=("color" "white" "select")
RESOLUTIONS=("1080p" "2k" "4k")

for theme in "${THEMES[@]}"; do
  for resolution in "${RESOLUTIONS[@]}"; do
    echo "./render-assets.sh \"$theme\" \"$resolution\": "
    ./render-assets.sh "$theme" "$resolution"
  done
done
