// swift-tools-version: 5.9

import PackageDescription

let version = "1.13.0"
let checksumSherpaOnnx = "39ec223df7f1dd7982c9741f6541d027d80e81c65a3409c15b25c445c264621c"
let checksumOnnxRuntime = "738689591fa0811c3e78942504a0b25f24b7543ba593b52dc461d3ecf4f6a086"

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
