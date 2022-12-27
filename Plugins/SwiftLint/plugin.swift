import Foundation
import PackagePlugin
import XcodeProjectPlugin

@main
@available(macOS 13.0, *)
struct SwiftLintPlugin: BuildToolPlugin, XcodeBuildToolPlugin {

	func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
		let configPath = "\(context.package.directory.string)/.swiftlint.yml"
		guard FileManager.default.fileExists(atPath: configPath) else {
			// swiftlint:disable:next line_length
			Diagnostics.remark("No SwiftLint configuration found at path \"\(configPath)\". If you would like to use SwiftLint for this target, create a `.swiftlint.yml` file at this path.")
			return []
		}

		let command = PackagePlugin.Command.buildCommand(
			displayName: "Running SwiftLint for \(target.name)",
			executable: try context.tool(named: "swiftlint").path,
			arguments: [
				"lint",
				"--in-process-sourcekit",
				"--path", target.directory.string,
				"--config", configPath
			],
			environment: [:]
		)
		return [command]
	}

	func createBuildCommands(context: XcodeProjectPlugin.XcodePluginContext, target: XcodeProjectPlugin.XcodeTarget) throws -> [PackagePlugin.Command] {
		let projectPath = context.xcodeProject.directory
		let configPath = "\(projectPath)/.swiftlint.yml"
		guard FileManager.default.fileExists(atPath: configPath) else {
			// swiftlint:disable:next line_length
			Diagnostics.remark("No SwiftLint configuration found at path \"\(configPath)\". If you would like to use SwiftLint for this target (\(target.displayName)), create a `.swiftlint.yml` file at this path.")
			return []
		}

		let command = PackagePlugin.Command.buildCommand(
			displayName: "Running SwiftLint for \(target.displayName)",
			executable: try context.tool(named: "swiftlint").path,
			arguments: [
				"lint",
				"--in-process-sourcekit",
				"--path", projectPath,
				"--config", configPath
			],
			environment: [:]
		)
		return [command]
	}
}
