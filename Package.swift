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
		// Data Tools
		.target(name: "DataTools"),
		.testTarget(name: "DataToolsTests", dependencies: ["DataTools"]),
		// NBT (Encoders, Decoders, Tags, Types, etc.)
		.target(name: "MinecraftNBT", dependencies: ["DataTools"]),
		.testTarget(name: "MinecraftNBTTests", dependencies: ["MinecraftNBT"]),
		// NBT Structures
		.target(name: "NBTStructures"),
		// Executable
		.executableTarget(name: "MinecraftTools", dependencies: ["MinecraftNBT", "DataTools", "NBTStructures"]),
	]
)
