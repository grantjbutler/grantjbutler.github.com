import Publish

extension PublishingStep where Site == GrantJButler {
    static func addDefaultSectionTitles() -> Self {
        .step(named: "Default section titles") { context in
            context.mutateAllSections { section in
                guard section.title.isEmpty else { return }
                
                switch section.id {
                case .articles:
                    section.title = "Articles"
                }
            }
        }
    }
}
