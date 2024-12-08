// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-sentencepiece",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1),
    ],
    products: [
        .executable(
            name: "sentencepiece-cli",
            targets: ["SentencepieceCLI"]
        ),
        .library(
            name: "SentencepieceTokenizer",
            targets: ["SentencepieceTokenizer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0")
    ],
    targets: [
        .executableTarget(
            name: "SentencepieceCLI",
            dependencies: [
                "SentencepieceTokenizer",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .binaryTarget(
            name: "Sentencepiece",
            url:
                "https://github.com/jkrukowski/swift-sentencepiece/releases/download/0.0.5/sentencepiece.xcframework.zip",
            checksum: "4b3b3fefc5ce55edd9fa8b0133b1027db19d3c2b27c63e993727aebe2b3545a8"
        ),
        .target(
            name: "SentencepieceTokenizer",
            dependencies: [
                "Sentencepiece"
            ],
            linkerSettings: [
                .linkedLibrary("c++"),
                .linkedLibrary("stdc++")
            ]
        ),
        .testTarget(
            name: "SentencepieceTokenizerTests",
            dependencies: [
                "SentencepieceTokenizer"
            ],
            resources: [
                .copy("Model")
            ]
        ),
    ]
)
