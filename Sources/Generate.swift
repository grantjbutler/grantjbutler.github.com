import ReadingTimePublishPlugin
import Publish

func generateSite() throws {
    try GrantJButler().publish(using: [
        .addMarkdownFiles(),
        .installPlugin(.readingTime()),
        .addDefaultSectionTitles(),
        .copyResources(at: "Resources/img", to: "img"),
        .generateTailwindCSS(),
        .generateHTML(withTheme: .grantJButler, indentation: .spaces(2)),
        .generateRSSFeed(including: [.articles]),
        .generateSiteMap(),
        .generateCNAME(with: ["grantjbutler.com"])
    ])
}
