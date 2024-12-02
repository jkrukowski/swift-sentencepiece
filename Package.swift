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
                "https://github.com/jkrukowski/swift-sentencepiece/releases/download/0.0.4/sentencepiece.xcframework.zip",
            checksum: "9168a242ffc75cdecb3bd21f4671842bb48d583d1cbc83e5a255d3e348622680"
        ),
        .target(
            name: "SentencepieceTokenizer",
            dependencies: [
                "Sentencepiece"
            ],
            linkerSettings: [
                .unsafeFlags(
                    ["-lc++"],
                    .when(platforms: [.visionOS])
                )
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
