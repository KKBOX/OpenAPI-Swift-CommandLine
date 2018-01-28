// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "OpenAPI-Swift-CommandLine",
    dependencies: [
         .package(url: "https://github.com/KKBOX/OpenAPI-Swift", .upToNextMinor(from: "1.1.2"))
    ],
    targets: [
        .target(
            name: "kkbox",
            dependencies: ["KKBOXOpenAPISwift"]),
    ]
)
