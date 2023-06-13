// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SwiftLintPlugin",
	products: [
		.plugin(name: "SwiftLintPlugin", targets: ["SwiftLint"]),
		// .plugin(name: "SwiftLintFixPlugin", targets: ["Fix with SwiftLint"])
	],
	dependencies: [],
	targets: [
		.plugin(
			name: "SwiftLint",
			capability: .buildTool(),
			dependencies: ["SwiftLintBinary"]),
		// .plugin(
		// 	name: "Fix with SwiftLint",
		// 	capability: .command(intent: .sourceCodeFormatting(),
		// 						 permissions: [.writeToPackageDirectory(reason: "Allows plugin to fix issues in files.")]),
		// 	dependencies: ["SwiftLintBinary"],
		// 	path: "Plugins/SwiftLintFix"),
		.binaryTarget(
			name: "SwiftLintBinary",
			url: "https://github.com/realm/SwiftLint/releases/download/0.52.2/SwiftLintBinary-macos.artifactbundle.zip",
			checksum: "89651e1c87fb62faf076ef785a5b1af7f43570b2b74c6773526e0d5114e0578e")
	]
)
