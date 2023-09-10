import ReadingTimePublishPlugin
import TailwindPublishPlugin
import Publish

func generateSite() throws {
    try GrantJButler().publish(using: [
        .addMarkdownFiles(),
        .installPlugin(.readingTime()),
        .addDefaultSectionTitles(),
        .copyResources(at: "Resources/img", to: "img"),
        .installPlugin(.tailwind()),
        .generateHTML(withTheme: .grantJButler, indentation: .spaces(2)),
        .generateRSSFeed(including: [.articles]),
        .generateSiteMap(),
        .generateCNAME(with: ["grantjbutler.com"]),
        .disableJekyllBuild,
        .deploy(using: .gitHub("grantjbutler/grantjbutler.github.com", branch: "gh-pages"))
    ])
}
