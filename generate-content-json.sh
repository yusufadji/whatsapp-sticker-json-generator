#!/bin/bash

# -----------------------------------------------------------------------------
# Script: generate-content-json.sh
# Description: This script is used to automatically update contents.json
#            based on the folders containing stickers (.webp files) 
#            inside the assets folder.
#
# Functions:
# 1. Check if the sticker folder has a .png file as a tray image.
# 2. Checks if there are between 3 to 30 .webp files in the stickers folder.
# 3. Checks the size of .webp files and gives a warning if the file exceeds 500 KB.
# 4. Generates contents.json with data taken from the stickers folder.
#
# Note:
# - This script only supports sticker files in .webp format.
# - PNG files are used as tray images, if not found, the folder is not
#   included in contents.json.
# - This script randomly selects emojis for each sticker. 
#   This is done to save time. If you want to add emojis manually,
#   you can modify it yourself.
#
# Usage:
# Setup your assets path first and then run this script by running the command ./generate-content-json.sh on the terminal
#
# -----------------------------------------------------------------------------

# [MODIFY THIS]
# Setup your assets folder path and contents.json file path
ASSETS_PATH="/home/frelein/Desktop/projects/android/stiker-wa/freleinstk/app/src/main/assets"
CONTENTS_JSON_PATH="/home/frelein/Desktop/projects/android/stiker-wa/freleinstk/app/src/main/assets/contents.json"
ANDROID_PLAY_STORE_LINK=""
IOS_APP_STORE_LINK=""
PUBLISHER_NAME="Frelein"
PUBLISHER_EMAIL="admin@frelein.my.id"
PUBLISHER_WEBSITE=""
PRIVACY_POLICY_WEBSITE=""
LICENSE_AGREEMENT_WEBSITE=""
ANIMATED_STICKER_PACK=true
AVOID_CACHE=false

# A list of emojis to be randomized and put into an array
emojis_list=("😊" "😢" "😡" "😞")

# Function to get the image_data_version version from the previous contents.json file
get_image_data_version() {
    if [ -f "$CONTENTS_JSON_PATH" ]; then
        # Find the highest value from the previous image_data_version
        last_version=$(jq '.sticker_packs[]?.image_data_version' "$CONTENTS_JSON_PATH" | sort -nr | head -n1)
        if [ -z "$last_version" ]; then
            echo 1
        else
            echo $((last_version + 1))
        fi
    else
        echo 1
    fi
}

# Function to change identifier to capitalize and remove numbers
format_name() {
    # Replace _ with spaces, remove numbers, and capitalize
    echo "$1" | sed -E 's/[0-9]+//g' | sed 's/_/ /g' | sed 's/\b\(.\)/\u\1/g'
}

# Function to select emoji randomly
get_random_emoji() {
    echo "${emojis_list[$((RANDOM % 4))]}"
}

# Function to create contents.json
generate_json() {
    version=$(get_image_data_version)
    
    echo '{' > "$CONTENTS_JSON_PATH"
    echo '  "android_play_store_link": "'"$ANDROID_PLAY_STORE_LINK"'",' >> "$CONTENTS_JSON_PATH"
    echo '  "ios_app_store_link": "'"$IOS_APP_STORE_LINK"'",' >> "$CONTENTS_JSON_PATH"
    echo '  "sticker_packs": [' >> "$CONTENTS_JSON_PATH"
    
    first_pack=true
    for folder in "$ASSETS_PATH"/*; do
        if [ -d "$folder" ]; then
            # Get folder name as identifier
            pack_name=$(basename "$folder")

            # Formats sticker name from identifier
            formatted_name=$(format_name "$pack_name")

            # Tray images check
            png_files=("$folder"/*.png)
            if [ ${#png_files[@]} -eq 0 ]; then
                echo "Warning: There's no PNG file on '$pack_name'. This folder will not be included in contents.json."
                continue # Skip this folder if there's no PNG file
            fi

            # Get PNG file name
            tray_image_file=$(basename "${png_files[0]}")

            # Get sticker files in folder (.webp only)
            stickers=("$folder"/*.webp) # Using array to store .webp files
            sticker_count=${#stickers[@]} # Counting the number of .webp files

            # Checking the number of .webp files
            if [ "$sticker_count" -lt 3 ] || [ "$sticker_count" -gt 30 ]; then
                echo "Warning: '$pack_name' folder has $sticker_count .webp files. Must be between 3 and 30."
                continue # Skip this folder if it does not meet the requirements
            fi

            # Checking .webp file size
            oversized_files=()
            for sticker in "${stickers[@]}"; do
                file_size=$(stat -c%s "$sticker") # Get file size in bytes
                if [ "$file_size" -gt $((500 * 1024)) ]; then # 500 KB = 500 * 1024 byte
                    oversized_files+=("$(basename "$sticker") on folder '$pack_name'")
                fi
            done

            # If any file is larger than 500 KB, display a warning.
            if [ ${#oversized_files[@]} -gt 0 ]; then
                for oversized_file in "${oversized_files[@]}"; do
                    echo "Warning: File $oversized_file has a size of more than 500 KB."
                done
                continue # Skip this folder if there are oversized files.
            fi

            # If the .webp file is valid, continue writing to JSON.
            if [ "$sticker_count" -gt 0 ]; then
                # Add comma if not first pack
                if [ "$first_pack" = false ]; then
                    echo ',' >> "$CONTENTS_JSON_PATH"
                fi
                first_pack=false

                # Write a pack into JSON with all requested fields
                echo '    {' >> "$CONTENTS_JSON_PATH"
                echo '      "identifier": "'"$pack_name"'",' >> "$CONTENTS_JSON_PATH"
                echo '      "name": "'"$formatted_name"'",' >> "$CONTENTS_JSON_PATH"
                echo '      "publisher": "'"$PUBLISHER_NAME"'",' >> "$CONTENTS_JSON_PATH"
                echo '      "tray_image_file": "'"$tray_image_file"'",' >> "$CONTENTS_JSON_PATH"
                echo '      "image_data_version": '"$version"',' >> "$CONTENTS_JSON_PATH"
                echo '      "avoid_cache": "'"$AVOID_CACHE"'",' >> "$CONTENTS_JSON_PATH"
                echo '      "publisher_email": "'"$PUBLISHER_EMAIL"'",' >> "$CONTENTS_JSON_PATH"
                echo '      "publisher_website": "'"$PUBLISHER_WEBSITE"'",' >> "$CONTENTS_JSON_PATH"
                echo '      "privacy_policy_website": "'"$PRIVACY_POLICY_WEBSITE"'",' >> "$CONTENTS_JSON_PATH"
                echo '      "license_agreement_website": "'"$LICENSE_AGREEMENT_WEBSITE"'",' >> "$CONTENTS_JSON_PATH"
                echo '      "animated_sticker_pack": "'"$ANIMATED_STICKER_PACK"'",' >> "$CONTENTS_JSON_PATH"
                echo '      "stickers": [' >> "$CONTENTS_JSON_PATH"

                # Adding .webp stickers into JSON with image_file and emojis format
                first_sticker=true
                for sticker in "${stickers[@]}"; do
                    sticker_name=$(basename "$sticker")
                    random_emoji=$(get_random_emoji)
                    if [ "$first_sticker" = false ]; then
                        echo ',' >> "$CONTENTS_JSON_PATH"
                    fi
                    first_sticker=false
                    echo '        {' >> "$CONTENTS_JSON_PATH"
                    echo '          "image_file": "'"$sticker_name"'",' >> "$CONTENTS_JSON_PATH"
                    echo '          "emojis": ["'"$random_emoji"'"]' >> "$CONTENTS_JSON_PATH"
                    echo '        }' >> "$CONTENTS_JSON_PATH"
                done

                # Closing the sticker array and pack
                echo '      ]' >> "$CONTENTS_JSON_PATH"
                echo '    }' >> "$CONTENTS_JSON_PATH"
            fi
        fi
    done

    # Closing JSON
    echo '  ]' >> "$CONTENTS_JSON_PATH"
    echo '}' >> "$CONTENTS_JSON_PATH"
}

# Run the generate_json function
generate_json

echo "contents.json has been updated!"
