import Publish

func generateSite() throws {
    try GrantJButler().publish(using: [
        .addMarkdownFiles(),
        .addDefaultSectionTitles(),
        .copyResources(at: "Resources/img", to: "img"),
        .generateTailwindCSS(),
        .generateHTML(withTheme: .grantJButler, indentation: .spaces(2)),
        .generateRSSFeed(including: [.articles]),
        .generateSiteMap()
    ])
}
