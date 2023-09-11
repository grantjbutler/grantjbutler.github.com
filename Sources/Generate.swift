import ReadingTimePublishPlugin
import TailwindPublishPlugin
import Publish

func generateSite(isDeploy: Bool) throws {
    try GrantJButler(isDeploy: isDeploy).publish(using: [
        .highlightSyntax(),
        .addMarkdownFiles(),
        .filterDraftContent,
        .installPlugin(.readingTime()),
        .addDefaultSectionTitles(),
        .copyResources(at: "Resources/img", to: "img"),
        .installPlugin(.tailwind()),
        .generateHTML(withTheme: .grantJButler, indentation: .spaces(2)),
        .generateRSSFeed(including: [.articles]),
        .generateSiteMap(),
        .generateCNAME(with: ["grantjbutler.com"]),
//        .disableJekyllBuild,
        .deploy(using: .gitHub("grantjbutler/grantjbutler.github.com", branch: "gh-pages"))
    ])
}
