// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "DataLayer",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "DataLayer",
            targets: ["DataLayer"])
    ],
    dependencies: [
        .package(path: "../Models")
    ],
    targets: [
        .target(
            name: "DataLayer",
            dependencies: ["Models"]),
        .testTarget(
            name: "DataLayerTests",
            dependencies: ["DataLayer"])
    ]
)

