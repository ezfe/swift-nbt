// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "MinecraftTools",
    products: [
        .library(name: "MinecraftNBT", targets: ["MinecraftNBT"]),
    ],
    dependencies: [

    ],
    targets: [
        .target(name: "MinecraftTools", dependencies: ["MinecraftNBT",
                                                       "DataTools"]),
        
        .target(name: "DataTools"),
        .target(name: "MinecraftNBT", dependencies: ["DataTools"]),
    ]
)
