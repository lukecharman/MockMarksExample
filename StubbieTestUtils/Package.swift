// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "StubbieTestUtils",
    products: [
        .library(
            name: "StubbieTestUtils",
            targets: ["StubbieTestUtils"]
        ),
    ],
    targets: [
        .target(
            name: "StubbieTestUtils",
            dependencies: []
        )
    ]
)
