// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "GithubBot",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.2.0"),

        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor-community/vapor-ext.git", from: "0.3.3"),
        .package(url: "https://github.com/twof/Boomerang.git", from: "0.0.2")
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentPostgreSQL", "Vapor", "VaporExt", "Boomerang"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

