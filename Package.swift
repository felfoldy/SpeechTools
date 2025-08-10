// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "SpeechTools",
    platforms: [.iOS(.v14), .macOS(.v12), .visionOS(.v2)],
    products: [
        .library(
            name: "SpeechTools",
            targets: ["SpeechTools"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/felfoldy/LogTools", from: "1.0.1"),
        .package(url: "https://github.com/felfoldy/SwiftPy", from: "0.12.0"),
    ],
    targets: [
        .target(name: "SpeechTools",
                dependencies: ["LogTools", "SwiftPy"]),
        .testTarget(name: "SpeechToolsTests",
                    dependencies: ["SpeechTools"]),
    ]
)
