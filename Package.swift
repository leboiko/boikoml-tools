// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "boikoml-tools",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        // .package(url: "https://github.com/leboiko/BoikoML_framework.git", majorVersion:1),
        // .package(url: "https://github.com/mtynior/ColorizeSwift.git", from: "1.2.1"),
        // .package(url: "https://github.com/Swiftline/Swiftline.git" ,from: "0.5.0"),
        // .package(url: "https://github.com/jatoben/CommandLine", from: "3.0.0-pre1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "boikoml-tools",
            dependencies: []),//,"CommandLine"]),
        .testTarget(
            name: "boikoml-toolsTests",
            dependencies: ["boikoml-tools"]),
    ]
)
