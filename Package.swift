// swift-tools-version: 5.9

import PackageDescription

let version = "1.12.40"
let checksumSherpaOnnx = "1919ec605b9105b2f8eae3b700fac6c5297cb2033c40fba073390c9ed19b6a40"
let checksumOnnxRuntime = "8962baf4472688729cd32c1cf28b2a921682e92bba3e9f2af27c00d863914d38"

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
