// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SwiftLintPlugin",
	products: [
		.plugin(name: "SwiftLint", targets: ["SwiftLint"]),
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
			url: "https://github.com/realm/SwiftLint/releases/download/0.50.3/SwiftLintBinary-macos.artifactbundle.zip",
			checksum: "abe7c0bb505d26c232b565c3b1b4a01a8d1a38d86846e788c4d02f0b1042a904")
	]
)
