// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iStoryKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "NetworkServiceAPI",
            targets: ["NetworkServiceAPI"]
        ),
        .library(
            name: "NetworkService",
            targets: ["NetworkService"]
        ),
        .library(
            name: "KeychainService",
            targets: ["KeychainService"]
        ),
        .library(
            name: "KeychainServiceAPI",
            targets: ["KeychainServiceAPI"]
        ),
        .library(
            name: "GoogleSignService",
            targets: ["GoogleSignInService"]
        ),
        .library(
            name: "UserDefaultsClient",
            targets: ["UserDefaultsClient"]
        ),
        .library(
            name: "Logging",
            type: .dynamic,
            targets: ["Logging"]
        )
    ],
    dependencies: [
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.0")),
        .package(name: "Nuke", url: "https://github.com/kean/Nuke.git", .upToNextMajor(from: "10.0.0")),
        .package(name: "GoogleSignIn", url: "https://github.com/google/GoogleSignIn-iOS", .exact("6.0.2"))
    ],
    targets: [
        .target(
            name: "NetworkServiceAPI",
            dependencies: []
        ),
        .target(
            name: "NetworkService",
            dependencies: ["NetworkServiceAPI", "KeychainServiceAPI", "Alamofire"]
        ),
        .target(
            name: "KeychainServiceAPI",
            dependencies: []
        ),
        .target(
            name: "KeychainService",
            dependencies: ["KeychainServiceAPI"]
        ),
        .target(
            name: "Logging",
            dependencies: []
        ),
        .target(
            name: "UserDefaultsClient",
            dependencies: []
        ),
        .target(
            name: "GoogleSignInService",
            dependencies: ["GoogleSignIn"]
        )
    ]
)
