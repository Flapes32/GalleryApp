// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "GalleryFeature",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "GalleryFeature",
            targets: ["GalleryFeature"])
    ],
    dependencies: [
        .package(path: "../Models"),
        .package(path: "../Core"),
        .package(path: "../NetworkLayer"),
        .package(path: "../DataLayer"),
        .package(path: "../DetailFeature")
    ],
    targets: [
        .target(
            name: "GalleryFeature",
            dependencies: ["Models", "Core", "NetworkLayer", "DataLayer", "DetailFeature"]),
        .testTarget(
            name: "GalleryFeatureTests",
            dependencies: ["GalleryFeature"])
    ]
)
