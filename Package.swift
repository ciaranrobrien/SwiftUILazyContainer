// swift-tools-version: 5.10

/**
*  SwiftUILazyContainer
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import PackageDescription

let package = Package(
    name: "SwiftUILazyContainer",
    platforms: [
        .iOS(.v14),
        .macCatalyst(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "SwiftUILazyContainer", targets: ["SwiftUILazyContainer"])
    ],
    targets: [
        .target(name: "SwiftUILazyContainer", dependencies: [])
    ]
)
