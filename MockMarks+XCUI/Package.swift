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
    dependencies: [
      .package(url: "https://github.com/Realm/SwiftLint", branch: "main"),
    ],
    targets: [
        .target(
            name: "MockMarks+XCUI",
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        )
    ]
)
