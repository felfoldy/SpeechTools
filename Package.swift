// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpeechTools",
    platforms: [.iOS(.v14), .macOS(.v12)],
    products: [
        .library(
            name: "SpeechTools",
            targets: ["SpeechTools"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/felfoldy/LogTools", branch: "main")
    ],
    targets: [
        .target(name: "SpeechTools",
                dependencies: ["LogTools"]),
        .testTarget(name: "SpeechToolsTests",
                    dependencies: ["SpeechTools"]),
    ]
)
