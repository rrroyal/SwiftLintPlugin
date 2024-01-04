// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "SwiftLintPlugin",
	products: [
		.plugin(name: "SwiftLintPlugin", targets: ["SwiftLint"]),
		.plugin(name: "SwiftLintFixPlugin", targets: ["Fix with SwiftLint"])
	],
	dependencies: [],
	targets: [
		.plugin(
			name: "SwiftLint",
			capability: .buildTool(),
			dependencies: ["SwiftLintBinary"]),
		 .plugin(
		 	name: "Fix with SwiftLint",
			capability: .command(
				intent: .sourceCodeFormatting(),
				permissions: [.writeToPackageDirectory(reason: "Allows plugin to fix issues in files.")]
			),
			dependencies: ["SwiftLintBinary"],
			path: "Plugins/SwiftLintFix"
		 ),
		.binaryTarget(
			name: "SwiftLintBinary",
			url: "https://github.com/realm/SwiftLint/releases/download/0.54.0/SwiftLintBinary-macos.artifactbundle.zip",
			checksum: "963121d6babf2bf5fd66a21ac9297e86d855cbc9d28322790646b88dceca00f1"
		)
	]
)
