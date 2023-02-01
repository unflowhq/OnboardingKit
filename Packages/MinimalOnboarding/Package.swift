// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MinimalOnboarding",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "MinimalOnboarding",
            targets: ["MinimalOnboarding"]
        )
    ],
    dependencies: [
        .package(name: "DesignHelpKit", path: "../DesignHelpKit"),
        .package(url: "https://github.com/pointfreeco/swiftui-navigation", from: "0.6.1")
    ],
    targets: [
        .target(
            name: "MinimalOnboarding",
            dependencies: [
                "DesignHelpKit",
                .product(name: "SwiftUINavigation", package: "swiftui-navigation")
            ],
            resources: [
                .process("Resources/Fonts"),
                .process("Resources/Assets.xcassets")
            ]
        ),
        .testTarget(
            name: "MinimalOnboardingTests",
            dependencies: ["MinimalOnboarding"])
    ]
)
