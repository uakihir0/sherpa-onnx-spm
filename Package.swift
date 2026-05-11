// swift-tools-version: 5.9

import PackageDescription

let version = "1.13.1"
let checksumSherpaOnnx = "41827df0c4e357c1bfc7be19eebccb95df4fcdd940527b5091b59f41a90c3a5a"
let checksumOnnxRuntime = "75d0d9197e38ab0eabac948aac68b6b3b3ddfd4c4706538070ba6bb22e490a51"

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
