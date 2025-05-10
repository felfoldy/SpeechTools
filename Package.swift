// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SpeechTools",
    platforms: [.iOS(.v14), .macOS(.v12), .visionOS(.v1)],
    products: [
        .library(
            name: "SpeechTools",
            targets: ["SpeechTools"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/felfoldy/LogTools", from: "1.0.1"),
    ],
    targets: [
        .target(name: "SpeechTools",
                dependencies: ["LogTools"]),
        .testTarget(name: "SpeechToolsTests",
                    dependencies: ["SpeechTools"]),
    ]
)
