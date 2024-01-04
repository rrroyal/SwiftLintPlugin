import Foundation
import PackagePlugin

// MARK: - SwiftLintFixPlugin

@main
struct SwiftLintFixPlugin {
	private func performCommand(
		projectPath: Path,
		configPath: Path?,
		tool: PluginContext.Tool
	) throws {
		guard let configPath,
			  FileManager.default.fileExists(atPath: configPath.string) else {
			// swiftlint:disable:next line_length
			Diagnostics.remark("No SwiftLint configuration found at path \"\(configPath?.string ?? "")\". If you would like to use SwiftLint for this target, create a `.swiftlint.yml` file at this path.")
			return
		}

		let process = Process()
		process.executableURL = URL(filePath: tool.path.string)
		process.arguments = [
			"lint",
			"--format",
			"--fix",
			"--in-process-sourcekit",
			"--path", projectPath.string,
			"--config", configPath.string
		]

		try process.run()
		process.waitUntilExit()
	}
}

// MARK: - SwiftLintFixPlugin+CommandPlugin

extension SwiftLintFixPlugin: CommandPlugin {
	func performCommand(context: PackagePlugin.PluginContext, arguments: [String]) async throws {
		let tool = try context.tool(named: "swiftlint")
		let projectPath = context.package.directory
		let configPath = projectPath.firstConfigurationFileInParentDirectories()

		try performCommand(
			projectPath: projectPath,
			configPath: configPath,
			tool: tool
		)
	}
}

// MARK: - SwiftLintFixPlugin+XcodeCommandPlugin

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftLintFixPlugin: XcodeCommandPlugin {
	func performCommand(context: XcodeProjectPlugin.XcodePluginContext, arguments: [String]) throws {
		let tool = try context.tool(named: "swiftlint")
		let projectPath = context.xcodeProject.directory
		let configPath = Path("\(projectPath)/.swiftlint.yml")

		try performCommand(
			projectPath: projectPath,
			configPath: configPath,
			tool: tool
		)
	}
}
#endif
