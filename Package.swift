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
        .iOS(.v13),
        .macCatalyst(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "SwiftUILazyContainer", targets: ["SwiftUILazyContainer"])
    ],
    targets: [
        .target(name: "SwiftUILazyContainer")
    ]
)
