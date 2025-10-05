// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SpeechTools",
    platforms: [.iOS(.v26), .macOS(.v26), .visionOS(.v26)],
    products: [
        .library(
            name: "SpeechTools",
            targets: ["SpeechTools"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/felfoldy/LogTools", from: "1.1.0"),
        .package(url: "https://github.com/felfoldy/SwiftPy", from: "0.13.2"),
    ],
    targets: [
        .target(name: "SpeechTools",
                dependencies: ["LogTools", "SwiftPy"]),
        .testTarget(name: "SpeechToolsTests",
                    dependencies: ["SpeechTools"]),
    ]
)
