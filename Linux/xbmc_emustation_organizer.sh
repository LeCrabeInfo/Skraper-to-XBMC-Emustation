#!/bin/bash

#################################
# Params
#################################

EMUSTATION_PATH="${1%/}"

#################################
# Constants
#################################

ROMS_PATH="$EMUSTATION_PATH/roms"
MEDIA_PATH="$EMUSTATION_PATH/media"
SYNOPSIS_PATH="$EMUSTATION_PATH/synopsis"
MAX_ROM_NAME_LEN=38

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # Escape sequence

#################################
# Functions
#################################

test_input_parameters() {

    # Ensure that emustation path is specified
    if [ -z "$EMUSTATION_PATH" ]; then
        echo -e "${RED}Error: Emustation path is required.${NC}"
        exit 1
    fi

    # Check that emustation path exists
    if [ ! -d "$EMUSTATION_PATH" ]; then
        echo -e "${RED}Error: The specified path '$EMUSTATION_PATH' does not exist.${NC}"
        exit 1
    fi

    # Check that roms path exists
    if [ ! -d "$ROMS_PATH" ]; then
        echo -e "${RED}Error: Directory '$ROMS_PATH' does not exist.${NC}"
        echo -e "${RED}Check your directory structure, it should be '<path_to_your_emustation/roms/<console_name>'.${NC}"
        exit 1
    fi
}

escape_for_xpath() {
    local input="$1"
    # Escape single quotes by replacing them with '\''
    input="${input//'/\\'}"
    # Escape double quotes for safety
    input="${input//\"/&quot;}"
    echo "$input"
}

move_media_script() {

    # Get all system directories inside emustation\roms
    for system_dir in "$ROMS_PATH"/*/; do
        system_name=$(basename "$system_dir")
        source_media_path="$system_dir/media"
        destination_path="$MEDIA_PATH/$system_name"

        # Check if media folder exists
        if [ ! -d "$source_media_path" ]; then
            echo -e "${YELLOW}Warning: media folder not found in $system_dir. Skipping...${NC}"
            continue
        fi

        # Create the destination folder
        if [ ! -d "$destination_path" ]; then
            mkdir -p "$destination_path"
        fi

        # Move the media files
        mv "$source_media_path"/* "$destination_path/"

        # Delete media folder
        rmdir "$source_media_path"
    done

    echo -e "${GREEN}Media folders have been moved successfully.${NC}"
}

generate_synopsis() {

    # Clear the synopsis directory if it exists
    if [ -d "$SYNOPSIS_PATH" ]; then
        echo -e "${YELLOW}Clearing existing synopsis directory: $SYNOPSIS_PATH${NC}"
        rm -rf "$SYNOPSIS_PATH"/*
    fi

    # Get all system directories inside emustation/roms
    for system_dir in "$ROMS_PATH"/*/; do
        system_name=$(basename "$system_dir")
        gamelist_path="$system_dir/gamelist.xml"
        destination_path="$SYNOPSIS_PATH/$system_name"

        # Check if gamelist.xml file exists
        if [ ! -f "$gamelist_path" ]; then
            echo -e "${YELLOW}Warning: gamelist.xml not found in $system_dir. Skipping...${NC}"
            continue
        fi

        # Create the destination folder
        mkdir -p "$destination_path"

        # Use xmllint to extract all game entries
        while IFS= read -r game_path; do
            # Skip empty lines
            [ -z "$game_path" ] && continue

            # Extract the base name for the output file
            base_name=$(basename "${game_path%.*}")
            output_file_path="$destination_path/$base_name.txt"

            # Escape single quotes for XPath by wrapping in double quotes
            # Replace ' with '\''
            escaped_game_path="${game_path//'/\\'}"
            # Use double quotes for the XPath predicate
            xpath_predicate="path=\"$escaped_game_path\""

            # Extract metadata using xmllint and XPath
            text_name=$(xmllint --xpath "//game[$xpath_predicate]/name/text()" "$gamelist_path" || echo "unknown")
            text_description=$(xmllint --xpath "//game[$xpath_predicate]/desc/text()" "$gamelist_path" || echo "unknown")
            text_rating=$(xmllint --xpath "//game[$xpath_predicate]/rating/text()" "$gamelist_path" || echo "unknown")
            text_release_date=$(xmllint --xpath "//game[$xpath_predicate]/releasedate/text()" "$gamelist_path" | sed 's/T.*//' || echo "unknown")
            text_developer=$(xmllint --xpath "//game[$xpath_predicate]/developer/text()" "$gamelist_path" || echo "unknown")
            text_publisher=$(xmllint --xpath "//game[$xpath_predicate]/publisher/text()" "$gamelist_path" || echo "unknown")
            text_genre=$(xmllint --xpath "//game[$xpath_predicate]/genre/text()" "$gamelist_path" || echo "unknown")
            text_players=$(xmllint --xpath "//game[$xpath_predicate]/players/text()" "$gamelist_path" || echo "at least 1")

            # Write output
            echo -e "Filename: $base_name\nName: $text_name\nRating: $text_rating\nRelease Year: ${text_release_date:0:4}\nDeveloper: $text_developer\nPublisher: $text_publisher\nGenre: $text_genre\nPlayers: $text_players\n_________________________\n$text_description" > "$output_file_path"
        done < <(xmllint --xpath "//game/path/text()" "$gamelist_path")

        # Delete gamelist.xml file
        rm -f "$gamelist_path"
    done

    echo -e "${GREEN}Synopsis files have been generated successfully.${NC}"
}

rename_files() {

    # Process all files recursively
    while IFS= read -r -d '' file; do
        # Get the filename without the path
        filename="$(basename "$file")"

        # Process the filename in one go
        new_name="$(echo "$filename" | sed -E '
            s:\[.*?\]::g;  # Remove brackets
            s:\(.*?\)::g;  # Remove parentheses
            s:\s+$::;      # Trim trailing spaces
            s:\s+\.:\.:g   # generate_synopsisRemove spaces before the extension
        ')"

        # Check if the filename length (without the extension) exceeds the maximum length
        name_without_extension="${new_name%.*}"
        if [ ${#name_without_extension} -gt $MAX_ROM_NAME_LEN ]; then
            extension="${new_name##*.}"
            new_name="${name_without_extension:0:$MAX_ROM_NAME_LEN}.${extension}"
        fi

        # Rename the file
        mv -v "$file" "$(dirname "$file")/$new_name" 1>/dev/null
    done < <(find "$EMUSTATION_PATH" -type f -print0)

    echo -e "${GREEN}Files have been renamed successfully.${NC}"
}

#################################
# Main
#################################

main() {
    echo -e "\n${CYAN}# Starting to move media folders...${NC}"
    move_media_script

    echo -e "\n${CYAN}# Starting to generate synopsis files...${NC}"
    generate_synopsis

    echo -e "\n${CYAN}# Starting to rename files...${NC}"
    rename_files

    echo -e "\n${GREEN}Operation completed successfully!${NC}"
}

main
