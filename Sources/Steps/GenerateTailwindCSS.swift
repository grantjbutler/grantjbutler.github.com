import Files
import Foundation
import Publish
import ShellOut

extension PublishingStep {
    static func generateTailwindCSS(
        inputPath: Path = "Resources/styles.css",
        outputPath: Path = "styles.css"
    ) -> PublishingStep {
        .installPlugin(.init(name: "Generate Tailwind CSS", installer: { context in
            let packageRoot: Folder
            do {
                packageRoot = try context.file(at: "tailwind.config.js").parent!
            } catch {
                throw TailwindCSSError.noConfigFile
            }
            
            do {
                _ = try context.file(at: inputPath)
            } catch {
                throw TailwindCSSError.noStyles
            }
            
            _ = try context.createOutputFile(at: outputPath)
            
            try shellOut(
                to: ProcessInfo.processInfo.environment["NPX_BINARY", default: "npx"],
                arguments: ["tailwindcss", "-i", context.file(at: inputPath).path, "-o", context.outputFile(at: outputPath).path, "--minify"],
                at: packageRoot.path
            )
        }))
    }
}

private enum TailwindCSSError: LocalizedError {
    case noConfigFile
    case noStyles
}
