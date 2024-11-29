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
                "https://github.com/jkrukowski/swift-sentencepiece/releases/download/v0.0.1/sentencepiece.xcframework.zip",
            checksum: "e2093b63b413664eefa25e3a2be27863c038fd54eb8a12f12563bab8da0f872a"
        ),
        .target(
            name: "SentencepieceTokenizer",
            dependencies: [
                "Sentencepiece"
            ]
        ),
        .testTarget(
            name: "SentencepieceTokenizerTests",
            dependencies: [
                "SentencepieceTokenizer"
            ],
            resources: [
                .copy("Model")
            ],
            linkerSettings: [
                .unsafeFlags([
                    "-lc++"
                ])
            ]
        ),
    ]
)
