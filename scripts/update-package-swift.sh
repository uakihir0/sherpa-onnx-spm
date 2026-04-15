#!/usr/bin/env bash
#
# Update the version and checksums in Package.swift.
#
set -euo pipefail

VERSION=""
CHECKSUM_SHERPA=""
CHECKSUM_ONNXRUNTIME=""

usage() {
  echo "Usage: $0 --version <X.Y.Z> --checksum-sherpa <hash> --checksum-onnxruntime <hash>"
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version) VERSION="$2"; shift 2 ;;
    --checksum-sherpa) CHECKSUM_SHERPA="$2"; shift 2 ;;
    --checksum-onnxruntime) CHECKSUM_ONNXRUNTIME="$2"; shift 2 ;;
    *) usage ;;
  esac
done

if [[ -z "$VERSION" || -z "$CHECKSUM_SHERPA" || -z "$CHECKSUM_ONNXRUNTIME" ]]; then
  usage
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
PACKAGE_SWIFT="${REPO_ROOT}/Package.swift"
VERSION_FILE="${REPO_ROOT}/versions/current-version.txt"

echo "--- Updating Package.swift ---"
echo "  Version: $VERSION"
echo "  Checksum (sherpa-onnx): $CHECKSUM_SHERPA"
echo "  Checksum (onnxruntime): $CHECKSUM_ONNXRUNTIME"

# Update Package.swift
sed -i '' "s|^let version = \".*\"|let version = \"${VERSION}\"|" "$PACKAGE_SWIFT"
sed -i '' "s|^let checksumSherpaOnnx = \".*\"|let checksumSherpaOnnx = \"${CHECKSUM_SHERPA}\"|" "$PACKAGE_SWIFT"
sed -i '' "s|^let checksumOnnxRuntime = \".*\"|let checksumOnnxRuntime = \"${CHECKSUM_ONNXRUNTIME}\"|" "$PACKAGE_SWIFT"

# Update versions/current-version.txt
echo "$VERSION" > "$VERSION_FILE"

echo "--- Updated successfully ---"
echo ""
grep -E "^let (version|checksum)" "$PACKAGE_SWIFT"
