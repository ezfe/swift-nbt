// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "MinecraftTools",
    products: [
        .library(name: "MinecraftNBT", targets: ["MinecraftNBT"]),
    ],
    dependencies: [
        .package(url: "https://github.com/1024jp/GzipSwift.git", from: "4.1.0"),
    ],
    targets: [
        .target(name: "MinecraftTools", dependencies: ["Gzip",
                                                       "MinecraftNBT",
                                                       "DataTools"]),
        
        .target(name: "DataTools"),
        .target(name: "MinecraftNBT", dependencies: ["DataTools"]),
    ]
)
