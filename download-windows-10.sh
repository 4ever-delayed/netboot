#!/usr/bin/env bash

LANG_CODE="en"
LANG_NAME="English"
ARCH="x64"
OUTPUT_DIR="/tmp"

# Get Lock so we can only have one instance of this script running
exec {lock_fd}>"/var/lock/`basename "$0"`" || exit 1
flock -n "$lock_fd" || { echo "ERROR: flock() failed." >&2; exit 1; }

LATEST_WINDOWS_VERSION=`curl -s -H "Accept: application/json" "https://tb.rg-adguard.net/php/get_version.php?type_id=1" | jq '.versions | sort_by(-(.version_id | tonumber))[0]'`

WINDOWS_NAME=`echo "$LATEST_WINDOWS_VERSION" | jq -r .name`
VERSION_ID=`echo "$LATEST_WINDOWS_VERSION" | jq -r .version_id`
EDITION_ID=`curl -s -H "Accept: application/json" "https://tb.rg-adguard.net/php/get_edition.php?version_id=${VERSION_ID}&lang=name_${LANG_CODE}" | jq -r '.editions[] | select(.name_'${LANG_CODE}'=="Windows 10").edition_id'`
LANGUAGE_ID=`curl -s -H "Accept: application/json" "https://tb.rg-adguard.net/php/get_language.php?edition_id=${EDITION_ID}&lang=name_${LANG_CODE}" | jq -r '.languages[] | select(.name_'${LANG_CODE}'=="'${LANG_NAME}'").language_id'`
ARCH_INFO=`curl -s -H "Accept: application/json" "https://tb.rg-adguard.net/php/get_arch.php?language_id=${LANGUAGE_ID}"`
FILE_NAME=`echo "$ARCH_INFO" | jq -r '.archs[] | select(.name | contains("'${ARCH}'")).name'`
ARCH_ID=`echo "$ARCH_INFO" | jq -r '.archs[] | select(.name | contains("'${ARCH}'")).arch_id'`
DOWNLOAD_INFO=`curl -s "https://tb.rg-adguard.net/dl.php?fileName=${ARCH_ID}&lang=en"`
DOWNLOAD_ID=`echo "$DOWNLOAD_INFO" | grep -oP '(?<=https:\/\/tb\.rg-adguard\.net/dl\.php\?go=)[0-9a-z]+'`
DOWNLOAD_URL="https://tb.rg-adguard.net/dl.php?go=${DOWNLOAD_ID}"
FILE_SIZE_MB=`echo "$DOWNLOAD_INFO" | grep -oP "(?<=File size: </b>)[0-9.]+"`
FILE_SIZE_BYTES=`echo "$DOWNLOAD_INFO" | grep -oP "(?<=File size: </b>)[0-9(). A-Z]+" | cut -d "(" -f2 | tr -d ' '`

echo "Found $WINDOWS_NAME"
if [ -f "$OUTPUT_DIR/$FILE_NAME" ]; then
  EXISTING_BYTES=`stat --printf="%s" "$OUTPUT_DIR/$FILE_NAME"`
  if [ "$EXISTING_BYTES" -eq "$FILE_SIZE_BYTES" ]; then
    echo "File already exists! Skipping download"
    # Release Lock
    flock -u "$lock_fd"
    exit 0
  else
    echo "File does exist but has wrong bytesize! (got $EXISTING_BYTES expected $FILE_SIZE_BYTES)"
    echo "Probably corrupt or incomplete - removing"
    rm "$OUTPUT_DIR/$FILE_NAME"
  fi
fi

echo "Downloading $FILE_NAME ($FILE_SIZE_MB MB [$FILE_SIZE_BYTES bytes])"
curl -s -L "$DOWNLOAD_URL" -o "$OUTPUT_DIR/$FILE_NAME"

# Release lock
flock -u "$lock_fd"