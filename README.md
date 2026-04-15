# sherpa-onnx-spm

A Swift Package Manager distribution of [sherpa-onnx](https://github.com/k2-fsa/sherpa-onnx) iOS XCFrameworks.

Automatically tracks the latest sherpa-onnx releases via GitHub Actions and provides pre-built XCFrameworks.

## Features

- Speech Recognition (ASR) - Streaming / Non-streaming
- Text-to-Speech (TTS) - VITS, Matcha, Kokoro, etc.
- Voice Activity Detection (VAD) - Silero VAD
- Keyword Spotting
- Speaker Identification & Diarization
- Speech Enhancement & Denoising

## Installation

### Swift Package Manager

In Xcode, go to **File > Add Package Dependencies...** and enter the following URL:

```
https://github.com/uakihir0/sherpa-onnx-spm.git
```

Or add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/uakihir0/sherpa-onnx-spm.git", from: "1.0.0")
]
```

Then add it to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "SherpaOnnx", package: "sherpa-onnx-spm"),
    ]
)
```

## Usage

```swift
import SherpaOnnx

// Check version
let version = getSherpaOnnxVersion()
print("sherpa-onnx version: \(version)")
```

For detailed usage, refer to the [official sherpa-onnx documentation](https://k2-fsa.github.io/sherpa/onnx/).

## Supported Platforms

- iOS 13.0+
  - arm64 (Device)
  - x86_64 (Simulator)
  - arm64 (Apple Silicon Simulator)

## License

sherpa-onnx is licensed under the [Apache License 2.0](https://github.com/k2-fsa/sherpa-onnx/blob/master/LICENSE).
