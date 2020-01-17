#!/bin/bash
# Script written by Ted Hart-Davis on 16th January 2020
# I realize what this uses is going to make it the ultimate "it works on my machine!111" experience

# Screen or no screen? (:
if [ "$1" = "--no-screen" ]; then
  use_screen="false"
else
  # Avoid creating a duplicate screen
  if [[ ! -z $(screen -ls | grep "lookout") ]]; then
    echo "It appears very probable that you are already running Lookout in a screen, stopping."
    exit
  fi
  use_screen="true"
  # Name the screen we may use (:
  screen_name="lookout"
fi

# Favicon file location
favicon_file="favicon_character.txt"

# Favicon character
favicon_character="$(cat "$favicon_file")"

# Generate a favicon to use from emoji as specified in the favicon_character
echo "Generating favicon"
convert -size 48x48 -gravity Center -background none -font noto-fonts-emoji -pointsize 32 pango:@"$favicon_file" static/favicon.png
echo "Favicon generated"

# If we have an index file, remove it, we're going to remake it (:
if [ -f "static/index.html" ]; then
  echo "Removing old index"
  rm "static/index.html"
fi

# Remake the index file as an effective clone; sed in the favicon
cat "static/index_pregen.html" | sed "s/insert_heartbeat_item/$favicon_character/" > "static/index.html"

# And so we start
echo "Trying to start Lookout"
if [ "$use_screen" = true ]; then
  echo "Creating a screen with name $screen_name"
  screen -d -m -S "$screen_name" python3 "lookout.py"
else
  echo "Not creating a screen."
  python3 lookout.py
fi

echo "Done."
