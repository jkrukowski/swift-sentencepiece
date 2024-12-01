// swift-tools-version: 5.9
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
                "https://github.com/jkrukowski/swift-sentencepiece/releases/download/0.0.3/sentencepiece.xcframework.zip",
            checksum: "22030b37c036acd5ff961da112df92880340bc04ad991ccb233a81e9c49b50c1"
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
