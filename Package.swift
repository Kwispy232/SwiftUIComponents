// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SwiftUIComponents",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "SwiftUIComponents",
            targets: ["SwiftUIComponents"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftUIComponents",
            dependencies: [],
            resources: [
                .process("Resources")
            ])
    ]
)
