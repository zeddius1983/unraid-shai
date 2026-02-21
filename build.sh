#!/bin/bash

# Build script for Shai Unraid Plugin
PLUGIN="shai"
VERSION=$(date +"%Y.%m.%d")
SOURCE_DIR="source/$PLUGIN"
OUTPUT_PKG="$PLUGIN.txz"

# Ensure all files have correct permissions before archiving
chmod -R 755 "$SOURCE_DIR/usr"
chmod -R 755 "$SOURCE_DIR/etc"
chmod +x "$SOURCE_DIR/usr/local/bin/shai"
chmod +x "$SOURCE_DIR/etc/profile.d/shai.sh" 

echo "Creating plugin archive $OUTPUT_PKG..."
cd "$SOURCE_DIR" || exit 1
# Unraid typically uses tar with xz compression
tar -cJf "../../$OUTPUT_PKG" *
cd ../../

# Output MD5 for the .plg file
MD5=$(md5sum "$OUTPUT_PKG" | awk '{print $1}')
echo "Build complete. Output: $OUTPUT_PKG"
echo "MD5: $MD5"
echo "Update shai.plg with this date version and MD5 sum."
