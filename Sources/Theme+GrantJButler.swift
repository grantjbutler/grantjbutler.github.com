import Plot
import Publish

extension Theme {
    static var grantJButler: Self {
        .init(htmlFactory: GrantJButlerHTMLFactory())
    }
}

private struct GrantJButlerHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Publish.Index, context: Publish.PublishingContext<Site>) throws -> Plot.HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body{
                H1(index.title)
            }
        )
    }
    
    func makeSectionHTML(for section: Publish.Section<Site>, context: Publish.PublishingContext<Site>) throws -> Plot.HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .body{
                H1(section.title)
            }
        )
    }
    
    func makeItemHTML(for item: Publish.Item<Site>, context: Publish.PublishingContext<Site>) throws -> Plot.HTML {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .body{
                H1(item.title)
            }
        )
    }
    
    func makePageHTML(for page: Publish.Page, context: Publish.PublishingContext<Site>) throws -> Plot.HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body{
                H1(page.title)
            }
        )
    }
    
    func makeTagListHTML(for page: Publish.TagListPage, context: Publish.PublishingContext<Site>) throws -> Plot.HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body{
                H1("Tags")
            }
        )
    }
    
    func makeTagDetailsHTML(for page: Publish.TagDetailsPage, context: Publish.PublishingContext<Site>) throws -> Plot.HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body{
                H1(page.tag.string)
            }
        )
    }
}
