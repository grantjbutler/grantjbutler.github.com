import Publish

extension PublishingStep where Site == GrantJButler {
    static var filterDraftContent: PublishingStep<Site> {
        .step(named: "Filter Draft Content") { context in
            guard context.site.isDeploy else { return }
            
            context.mutateAllSections { section in
                section.removeItems(matching: \.metadata.draft == true)
            }
        }
    }
}
