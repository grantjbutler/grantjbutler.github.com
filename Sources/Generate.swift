import Publish

func generateSite() throws {
    try GrantJButler().publish(using: [
        .addMarkdownFiles(),
//        .copyResources(),
        .generateTailwindCSS(),
        .generateHTML(withTheme: .grantJButler, indentation: .spaces(2)),
        .generateRSSFeed(including: [.articles]),
        .generateSiteMap()
    ])
}
