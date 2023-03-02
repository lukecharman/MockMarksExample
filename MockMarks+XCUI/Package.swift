// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "MockMarks+XCUI",
    products: [
        .library(
            name: "MockMarks+XCUI",
            targets: ["MockMarks+XCUI"]
        ),
    ],
    targets: [
        .target(
            name: "MockMarks+XCUI",
            dependencies: []
        )
    ]
)
