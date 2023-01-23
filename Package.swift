// swift-tools-version:5.7

import PackageDescription

let package = Package(
	name: "MinecraftTools",
	platforms: [
		.macOS(.v13)
	],
	products: [
		.library(name: "MinecraftNBT", targets: ["MinecraftNBT"]),
	],
	dependencies: [
		
	],
	targets: [
		.executableTarget(name: "MinecraftTools", dependencies: ["MinecraftNBT", "DataTools"]),
		
			.target(name: "DataTools"),
		.target(name: "MinecraftNBT", dependencies: ["DataTools"]),
		
			.testTarget(
				name: "MinecraftToolsTests",
				dependencies: ["MinecraftNBT", "DataTools"]),
	]
)
