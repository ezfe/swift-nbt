// swift-tools-version:5.7

import PackageDescription

let package = Package(
	name: "swift-nbt",
	platforms: [
		.macOS(.v13)
	],
	products: [
		.library(name: "MinecraftNBT", targets: ["MinecraftNBT"]),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.1.0"),
		.package(url: "https://github.com/apple/swift-collections.git", from: "1.0.4"),
		.package(url: "https://github.com/1024jp/GzipSwift.git", from: "5.2.0")
	],
	targets: [
		// Data Tools
		.target(name: "DataTools"),
		.testTarget(name: "DataToolsTests", dependencies: ["DataTools"]),
		// NBT (Encoders, Decoders, Tags, Types, etc.)
		.target(name: "MinecraftNBT", dependencies: [
			"DataTools",
			.product(name: "OrderedCollections", package: "swift-collections"),
			.product(name: "Gzip", package: "GzipSwift")
		]),
		.testTarget(name: "MinecraftNBTTests", dependencies: ["MinecraftNBT"]),
		// NBT Structures
		.target(name: "NBTStructures"),
		// Executable
		.executableTarget(name: "MinecraftTools", dependencies: ["MinecraftNBT", "DataTools", "NBTStructures"]),
	]
)
