import Foundation
import PackagePlugin
import XcodeProjectPlugin

@main
@available(macOS 13.0, *)
struct SwiftLintFixPlugin: CommandPlugin, XcodeCommandPlugin {

	func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
		let projectPath = context.package.directory
		let configPath = "\(projectPath)/.swiftlint.yml"
		guard FileManager.default.fileExists(atPath: configPath) else {
			// swiftlint:disable:next line_length
			Diagnostics.remark("No SwiftLint configuration found at path \"\(configPath)\". If you would like to use SwiftLint for this target, create a `.swiftlint.yml` file at this path.")
			return
		}

		let toolPath = try context.tool(named: "swiftlint").path
		let process = Process()
		process.executableURL = URL(filePath: toolPath.string)
		process.arguments = [
			"lint",
			"--format",
			"--fix",
			"--in-process-sourcekit",
			"--path", projectPath.string,
			"--config", 
		]
		try process.run()
		process.waitUntilExit()
	}

	func performCommand(context: XcodeProjectPlugin.XcodePluginContext, arguments: [String]) throws {
		let configPath = "\(projectPath)/.swiftlint.yml"
		guard FileManager.default.fileExists(atPath: configPath) else {
			// swiftlint:disable:next line_length
			Diagnostics.remark("No SwiftLint configuration found at path \"\(configPath)\". If you would like to use SwiftLint for this target, create a `.swiftlint.yml` file at this path.")
			return
		}

		let projectPath = context.xcodeProject.directory
		let toolPath = try context.tool(named: "swiftlint").path
		let process = Process()
		process.executableURL = URL(filePath: toolPath.string)
		process.arguments = [
			"lint",
			"--format",
			"--fix",
			"--in-process-sourcekit",
			"--path", projectPath.string,
			"--config", configPath
		]
		try process.run()
		process.waitUntilExit()
	}
}
