// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "MockMarks",
    products: [
        .library(
            name: "MockMarks",
            targets: ["MockMarks"]
        ),
    ],
    dependencies: [
      .package(url: "https://github.com/Realm/SwiftLint", branch: "main"),
    ],
    targets: [
        .target(
            name: "MockMarks",
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
        ),
        .testTarget(
            name: "MockMarksTests",
            dependencies: ["MockMarks"],
            resources: [
              .process("Resources")
            ]
        ),
    ]
)
