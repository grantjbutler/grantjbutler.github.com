import Publish

extension PublishingStep where Site == GrantJButler {
    static func overridePublishDates() -> Self {
        .step(named: "Override publish dates") { context in
            context.mutateAllSections { section in
                section.mutateItems { item in
                    item.date = item.metadata.publishDate
                }
            }
        }
    }
}
