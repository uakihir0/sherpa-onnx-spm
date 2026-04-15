// swift-tools-version: 5.9

import PackageDescription

let version = "0.0.0"
let checksumSherpaOnnx = "PLACEHOLDER"
let checksumOnnxRuntime = "PLACEHOLDER"

let package = Package(
    name: "SherpaOnnx",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "SherpaOnnx",
            targets: ["SherpaOnnx"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "sherpa-onnx",
            url: "https://github.com/uakihir0/sherpa-onnx-spm/releases/download/\(version)/sherpa-onnx.xcframework.zip",
            checksum: checksumSherpaOnnx
        ),
        .binaryTarget(
            name: "onnxruntime",
            url: "https://github.com/uakihir0/sherpa-onnx-spm/releases/download/\(version)/onnxruntime.xcframework.zip",
            checksum: checksumOnnxRuntime
        ),
        .target(
            name: "SherpaOnnx",
            dependencies: ["sherpa-onnx", "onnxruntime"],
            path: "Sources/SherpaOnnx",
            linkerSettings: [
                .linkedLibrary("c++"),
                .linkedFramework("Accelerate"),
            ]
        ),
    ]
)
