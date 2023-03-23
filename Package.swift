// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "MockMarks",
    products: [
        .library(
            name: "MockMarks",
            targets: ["MockMarks"]
        ),
        .library(
            name: "MockMarks+XCUI",
            targets: ["MockMarks+XCUI"]
        ),
    ],
    targets: [
        .target(
            name: "MockMarks"
        ),
        .target(
            name: "MockMarks+XCUI"
        ),
    ]
)
