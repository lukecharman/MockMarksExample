// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Stubbie",
    products: [
        .library(
            name: "Stubbie",
            targets: ["Stubbie"]
        ),
    ],
    targets: [
        .target(
            name: "Stubbie",
            dependencies: []),
        .testTarget(
            name: "StubbieTests",
            dependencies: ["Stubbie"]),
    ]
)
