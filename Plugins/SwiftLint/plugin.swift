import Foundation
import PackagePlugin

// MARK: - SwiftLintPlugin

@main
struct SwiftLintPlugin {
	private func createBuildCommands(
		inputFiles: [Path],
		packageDirectory: Path,
		workingDirectory: Path,
		tool: PluginContext.Tool
	) -> [Command] {
        if inputFiles.isEmpty {
            // Don't lint anything if there are no Swift source files in this target
            return []
        }

        var arguments = [
			"lint",
//            "--quiet",
			"--cache-path", "\(workingDirectory)",
        ]

        // Manually look for configuration files, to avoid issues when the plugin does not execute our tool from the
        // package source directory.
        if let configuration = packageDirectory.firstConfigurationFileInParentDirectories() {
            arguments += ["--config", "\(configuration.string)"]
        }
		
        arguments += inputFiles.map(\.string)

        return [
            .buildCommand(
                displayName: "SwiftLint",
                executable: tool.path,
                arguments: arguments
            )
        ]
    }
}

// MARK: - SwiftLintPlugin+BuildToolPlugin

extension SwiftLintPlugin: BuildToolPlugin {
	func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
		guard let sourceTarget = target as? SourceModuleTarget else {
			return []
		}

		let inputFiles = sourceTarget.sourceFiles(withSuffix: "swift").map(\.path)
		let packageDirectory = context.package.directory
		let workingDirectory = context.pluginWorkDirectory
		let tool = try context.tool(named: "swiftlint")

		return createBuildCommands(
			inputFiles: inputFiles,
			packageDirectory: packageDirectory,
			workingDirectory: workingDirectory,
			tool: tool
		)
	}
}

// MARK: - SwiftLintPlugin+XcodeBuildToolPlugin

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftLintPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let inputFiles = target.inputFiles
            .filter { $0.type == .source && $0.path.extension == "swift" }
            .map(\.path)
		let packageDirectory = context.xcodeProject.directory
		let workingDirectory = context.pluginWorkDirectory
		let tool = try context.tool(named: "swiftlint")

        return createBuildCommands(
            inputFiles: inputFiles,
            packageDirectory: packageDirectory,
            workingDirectory: workingDirectory,
            tool: tool
        )
    }
}
#endif
