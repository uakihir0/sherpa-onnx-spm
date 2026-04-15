#!/usr/bin/env bash
#
# Clone sherpa-onnx, build iOS XCFrameworks, and inject modulemaps.
#
set -euo pipefail

VERSION=""
WORK_DIR="$(pwd)/build-work"

usage() {
  echo "Usage: $0 --version <X.Y.Z>"
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version) VERSION="$2"; shift 2 ;;
    *) usage ;;
  esac
done

if [[ -z "$VERSION" ]]; then
  usage
fi

echo "=== Building sherpa-onnx v${VERSION} for iOS ==="

# Working directory
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# Clone sherpa-onnx
echo "--- Cloning sherpa-onnx v${VERSION} ---"
git clone --depth 1 --branch "v${VERSION}" https://github.com/k2-fsa/sherpa-onnx.git
cd sherpa-onnx

# iOS build (with TTS, static library)
echo "--- Running build-ios.sh ---"
bash build-ios.sh

# Verify build artifacts
XCFW_DIR="build-ios/sherpa-onnx.xcframework"
if [[ ! -d "$XCFW_DIR" ]]; then
  echo "ERROR: sherpa-onnx.xcframework not found at $XCFW_DIR"
  exit 1
fi

echo "--- sherpa-onnx.xcframework built successfully ---"

# Inject modulemap into sherpa-onnx.xcframework
echo "--- Injecting modulemap into sherpa-onnx.xcframework ---"
for slice_dir in "$XCFW_DIR"/*/; do
  headers_dir="${slice_dir}Headers"
  if [[ -d "$headers_dir" ]]; then
    cat > "${headers_dir}/module.modulemap" << 'MODULEMAP'
module sherpa_onnx {
    header "sherpa-onnx/c-api/c-api.h"
    export *
}
MODULEMAP
    echo "  Injected modulemap into: ${headers_dir}"
  fi
done

# Locate onnxruntime.xcframework
echo "--- Locating onnxruntime.xcframework ---"
ONNX_XCFW_DIR="build-ios/ios-onnxruntime/onnxruntime.xcframework"
if [[ ! -d "$ONNX_XCFW_DIR" ]]; then
  echo "ERROR: onnxruntime.xcframework not found at $ONNX_XCFW_DIR"
  exit 1
fi

# Inject modulemap into onnxruntime.xcframework
echo "--- Injecting modulemap into onnxruntime.xcframework ---"
ONNX_HEADERS_DIR="${ONNX_XCFW_DIR}/Headers"
if [[ -d "$ONNX_HEADERS_DIR" ]]; then
  # onnxruntime may have a shared top-level Headers directory
  if [[ ! -f "${ONNX_HEADERS_DIR}/module.modulemap" ]]; then
    cat > "${ONNX_HEADERS_DIR}/module.modulemap" << 'MODULEMAP'
module onnxruntime {
    header "onnxruntime_c_api.h"
    export *
}
MODULEMAP
    echo "  Injected modulemap into: ${ONNX_HEADERS_DIR}"
  else
    echo "  modulemap already exists in: ${ONNX_HEADERS_DIR}"
  fi
fi

# Inject into per-platform slice Headers directories
for slice_dir in "$ONNX_XCFW_DIR"/*/; do
  if [[ -d "${slice_dir}" && "$(basename "$slice_dir")" != "Headers" ]]; then
    # Inject if the slice has a Headers directory
    if [[ -d "${slice_dir}Headers" && ! -f "${slice_dir}Headers/module.modulemap" ]]; then
      cat > "${slice_dir}Headers/module.modulemap" << 'MODULEMAP'
module onnxruntime {
    header "onnxruntime_c_api.h"
    export *
}
MODULEMAP
      echo "  Injected modulemap into: ${slice_dir}Headers"
    fi
  fi
done

# Copy artifacts to output directory
OUTPUT_DIR="${WORK_DIR}/output"
mkdir -p "$OUTPUT_DIR"
cp -R "$XCFW_DIR" "$OUTPUT_DIR/"
cp -R "$ONNX_XCFW_DIR" "$OUTPUT_DIR/"

echo ""
echo "=== Build completed ==="
echo "Output directory: $OUTPUT_DIR"
echo ""

# Verify architectures
echo "--- Verifying architectures ---"
for xcfw in "$OUTPUT_DIR"/*.xcframework; do
  echo "$(basename "$xcfw"):"
  for lib in "$xcfw"/*/*.a "$xcfw"/*/*/*.a 2>/dev/null; do
    if [[ -f "$lib" ]]; then
      echo "  $(basename "$(dirname "$lib")"): $(lipo -info "$lib" 2>/dev/null || echo "not a fat binary")"
    fi
  done
done
