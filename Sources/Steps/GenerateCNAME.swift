import Publish

extension PublishingStep {
    static func generateCNAME(with domains: [String]) -> Self {
        return .step(named: "Generate CNAME") { context in
            try context.createOutputFile(at: "CNAME").write(domains.joined(separator: "\n"), encoding: .utf8)
        }
    }
}
