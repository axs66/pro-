#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e
set -x  # Enable debug mode

# Define the directory containing .deb files
DEB_DIR="./debs"

# Ensure the debs directory exists
if [ ! -d "$DEB_DIR" ]; then
  echo "Directory $DEB_DIR does not exist."
  exit 1
fi

# List contents of DEB_DIR for debugging
echo "Contents of $DEB_DIR:"
ls -l "$DEB_DIR"

# Check if there are any .deb files
DEB_COUNT=$(ls "$DEB_DIR"/*.deb 2>/dev/null | wc -l)
if [ "$DEB_COUNT" -eq 0 ]; then
  echo "No .deb files found in $DEB_DIR"
  exit 1
fi

# Generate the Packages file
echo "Generating Packages file..."
dpkg-scanpackages -m "$DEB_DIR" -v > Packages

# Check if Packages file was generated successfully
if [ ! -f "Packages" ]; then
  echo "Packages file was not generated."
  exit 1
fi

# Compress the Packages file
echo "Compressing Packages file..."
bzip2 -fks Packages || echo "bzip2 failed"
gzip -fk Packages || echo "gzip failed"

# Create the Release file
echo "Creating Release file..."
cat <<EOF > Release
Origin: Axs Pro
Label: Axs Pro
Suite: stable
Version: 1.0
Codename: Axs Pro
Architectures: iphoneos-arm64 iphoneos-arm64e iphoneos-arm
Components: master
Description: 自用插件分享，有问题请卸载！！！
EOF
