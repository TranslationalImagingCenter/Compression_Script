#!/bin/bash

# Enable error handling
set -e

# Define the log file
LOG_FILE="compression_log_$(date +%Y%m%d).txt"
echo "Compression Log - $(date)" > "$LOG_FILE"
echo "============================================" >> "$LOG_FILE"

# Define the source directory (current directory)
SOURCE_DIR="$(pwd)"

# Define the compression method and level
COMPRESSION_LEVEL=19

# File extensions to skip (already compressed formats)
SKIP_EXTENSIONS=("zst" "zip" "7z" "rar" "gz" "tgz" "bz2" "xz" "tar" "lz4" "cab" "arj" "iso" "dmg" "pkg" "deb" "rpm")

# Exclude this script and the log file from processing
SCRIPT_NAME="$(basename "$0")"

# Description of the script
clear
echo "============================================"
echo "Zstandard Compression Script for Mac OS"
echo "============================================"
echo
echo "Description:"
echo "This script compresses each individual file in the current folder and all subfolders."
echo "- Skips files that are already compressed (e.g., .zst, .zip, etc.)."
echo "- Validates the compressed file's integrity using a checksum test."
echo "- Deletes the uncompressed file if the compressed file is valid."
echo "- Uses Zstandard compression at maximum level ($COMPRESSION_LEVEL)."
echo "- Generates a detailed log file ($LOG_FILE), which will NOT be compressed."
echo
echo "Legal Disclaimer:"
echo "This script is provided 'as is,' without any warranties. The user assumes all risks"
echo "associated with its use. The developers are not responsible for data loss, corruption,"
echo "or any unintended consequences."
echo
echo "============================================"
echo
read -p "Would you like to continue? (Y/N): " USER_INPUT
if [[ "$USER_INPUT" != "Y" && "$USER_INPUT" != "y" ]]; then
    echo "Script terminated by the user."
    exit 0
fi
echo
echo "You have chosen to proceed."
echo "This script will process all files in the folder where it is being run from, including all subfolders, by first compressing each uncompressed file individually, then verifying the integrity of the compressed version, and finally deleting the original uncompressed file only if the compression and verification steps are successful."
echo
read -p "Would you like to continue? (Y/N): " USER_INPUT
if [[ "$USER_INPUT" != "Y" && "$USER_INPUT" != "y" ]]; then
    echo "Script terminated by the user."
    exit 0
fi



# Recursively loop through all files
find "$SOURCE_DIR" -type f | while read -r FILE; do
    # Get file extension and filename
    EXT="${FILE##*.}"
    BASENAME="$(basename "$FILE")"

    # Skip script itself and log file
    if [[ "$BASENAME" == "$SCRIPT_NAME" || "$BASENAME" == "$LOG_FILE" ]]; then
        echo "Skipping script or log file: $FILE" >> "$LOG_FILE"
        continue
    fi

    # Skip files with already compressed extensions
    for SKIP in "${SKIP_EXTENSIONS[@]}"; do
        if [[ "$EXT" == "$SKIP" ]]; then
            echo "Skipping already compressed file: $FILE" >> "$LOG_FILE"
            continue 2
        fi
    done

    # Define compressed file path
    COMPRESSED_FILE="${FILE}.zst"

    # If a compressed file already exists, verify and delete original if valid
    if [[ -f "$COMPRESSED_FILE" ]]; then
        ORIGINAL_HASH=$(shasum -a 256 "$FILE" | awk '{print $1}')
        DECOMPRESSED_HASH=$(zstd -d -c "$COMPRESSED_FILE" | shasum -a 256 | awk '{print $1}')

        if [[ "$ORIGINAL_HASH" == "$DECOMPRESSED_HASH" ]]; then
            echo "OK: Verified compressed file $COMPRESSED_FILE. Deleting original: $FILE" | tee -a "$LOG_FILE"
            rm "$FILE"
        else
            echo "ERROR: Checksum mismatch for $COMPRESSED_FILE. Keeping original file: $FILE" | tee -a "$LOG_FILE"
        fi
    else
        # Compress file
        zstd -$COMPRESSION_LEVEL "$FILE" -o "$COMPRESSED_FILE"
        if [[ $? -eq 0 ]]; then
            # Verify compression by checking checksums
            ORIGINAL_HASH=$(shasum -a 256 "$FILE" | awk '{print $1}')
            DECOMPRESSED_HASH=$(zstd -d -c "$COMPRESSED_FILE" | shasum -a 256 | awk '{print $1}')

            if [[ "$ORIGINAL_HASH" == "$DECOMPRESSED_HASH" ]]; then
                echo "OK: Compressed and verified $FILE to $COMPRESSED_FILE. Deleting original." | tee -a "$LOG_FILE"
                rm "$FILE"
            else
                echo "ERROR: Verification failed for $COMPRESSED_FILE. Keeping original file." | tee -a "$LOG_FILE"
            fi
        else
            echo "ERROR: Compression failed for $FILE. Keeping original." | tee -a "$LOG_FILE"
        fi
    fi
done

# Summary
echo "============================================"
echo "Compression completed. See log file for details: $LOG_FILE"
echo "============================================"