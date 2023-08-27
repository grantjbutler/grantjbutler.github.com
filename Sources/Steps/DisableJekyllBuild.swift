import Publish

extension PublishingStep {
    static var disableJekyllBuild: Self {
        .step(named: "Disable Jekyll Build") { context in
            _ = try context.createOutputFile(at: ".nojekyll")
        }
    }
}
