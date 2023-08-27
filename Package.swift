// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "grantjbutler.github.com",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(url: "https://github.com/eonist/FileWatcher.git", from: "0.2.0"),
        .package(url: "https://github.com/JohnSundell/ShellOut", from: "2.3.0"),
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
        .package(url: "https://github.com/alexito4/ReadingTimePublishPlugin", from: "0.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "grantjbutler.github.com",
            dependencies: [
                .product(name: "Publish", package: "Publish"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "FileWatcher", package: "FileWatcher"),
                .product(name: "ShellOut", package: "ShellOut"),
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "ReadingTimePublishPlugin", package: "ReadingTimePublishPlugin")
            ],
            path: "Sources"),
    ]
)
