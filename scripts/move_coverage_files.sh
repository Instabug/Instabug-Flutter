#!/bin/bash

# Set source and target directories
TARGET_DIR="../../../coverage"


  # Create the target directory if it doesn't exist
  mkdir -p "$TARGET_DIR"

  mv "lcov.info" "$TARGET_DIR/lcov-${MELOS_PACKAGE_NAME}.info"

  echo "All files moved successfully."

