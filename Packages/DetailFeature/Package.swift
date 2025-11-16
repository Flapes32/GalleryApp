// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "DetailFeature",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "DetailFeature",
            targets: ["DetailFeature"])
    ],
    dependencies: [
        .package(path: "../Models"),
        .package(path: "../Core"),
        .package(path: "../DataLayer")
    ],
    targets: [
        .target(
            name: "DetailFeature",
            dependencies: ["Models", "Core", "DataLayer"]),
        .testTarget(
            name: "DetailFeatureTests",
            dependencies: ["DetailFeature"])
    ]
)
