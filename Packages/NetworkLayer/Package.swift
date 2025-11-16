// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "NetworkLayer",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "NetworkLayer",
            targets: ["NetworkLayer"])
    ],
    dependencies: [
        .package(path: "../Models"),
        .package(path: "../Core")
    ],
    targets: [
        .target(
            name: "NetworkLayer",
            dependencies: ["Models", "Core"]),
        .testTarget(
            name: "NetworkLayerTests",
            dependencies: ["NetworkLayer", "Models"])
    ]
)
