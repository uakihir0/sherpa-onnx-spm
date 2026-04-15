#!/usr/bin/env bash
#
# Zip an XCFramework and compute the SPM checksum.
#
set -euo pipefail

XCFW_PATH=""
OUTPUT_ZIP=""

usage() {
  echo "Usage: $0 <xcframework_path> <output_zip_name>"
  echo "Example: $0 output/sherpa-onnx.xcframework sherpa-onnx.xcframework.zip"
  exit 1
}

if [[ $# -ne 2 ]]; then
  usage
fi

XCFW_PATH="$1"
OUTPUT_ZIP="$2"

if [[ ! -d "$XCFW_PATH" ]]; then
  echo "ERROR: XCFramework not found: $XCFW_PATH"
  exit 1
fi

XCFW_NAME="$(basename "$XCFW_PATH")"

# Validate XCFramework structure
echo "--- Validating $XCFW_NAME ---"

if [[ ! -f "${XCFW_PATH}/Info.plist" ]]; then
  echo "ERROR: Info.plist not found in $XCFW_NAME"
  exit 1
fi

# Create zip (xcframework at root level)
echo "--- Creating zip: $OUTPUT_ZIP ---"
PARENT_DIR="$(dirname "$XCFW_PATH")"
pushd "$PARENT_DIR" > /dev/null
zip -ry "$OLDPWD/$OUTPUT_ZIP" "$XCFW_NAME" > /dev/null
popd > /dev/null

echo "  Created: $OUTPUT_ZIP ($(du -h "$OUTPUT_ZIP" | cut -f1))"

# Compute checksum
echo "--- Computing checksum ---"
CHECKSUM=$(swift package compute-checksum "$OUTPUT_ZIP")
echo "  Checksum: $CHECKSUM"

# Verify zip structure (xcframework should be at root)
echo "--- Verifying zip structure ---"
FIRST_ENTRY=$(zipinfo -1 "$OUTPUT_ZIP" | head -1)
if [[ "$FIRST_ENTRY" == "${XCFW_NAME}/"* || "$FIRST_ENTRY" == "${XCFW_NAME}" ]]; then
  echo "  OK: $XCFW_NAME is at root level"
else
  echo "  WARNING: $XCFW_NAME may not be at root level (first entry: $FIRST_ENTRY)"
fi

echo ""
echo "CHECKSUM=$CHECKSUM"
