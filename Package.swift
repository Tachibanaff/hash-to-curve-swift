// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "hash-to-curve",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "hash-to-curve",
            targets: ["hash-to-curve"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "CHashToCurve",
            dependencies: [
                .product(name: "_CryptoExtras", package: "swift-crypto"),
            ],
            path: "Sources/CHashToCurve"
        ),
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "hash-to-curve",
            dependencies: ["CHashToCurve"]
        ),
        .testTarget(
            name: "hash-to-curveTests",
            dependencies: ["hash-to-curve"]
        ),
    ]
)
