import Algorithms
import Foundation
import Plot
import Publish
import ReadingTimePublishPlugin

extension Theme where Site == GrantJButler {
    static var grantJButler: Self {
        .init(htmlFactory: GrantJButlerHTMLFactory())
    }
}

private struct GrantJButlerHTMLFactory: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<GrantJButler>) throws -> HTML {
        MainLayout(context: context, location: index) {
            Container {
                H1("Hi! I'm Grant!")
                    .class("text-4xl font-bold")
            }
            
            HomepageSection(title: "I make iOS, macOS, and web apps.") {
                Div {
                    HomepageDetails(title: "Twitch", subtitle: "iOS Engineering", link: URL(string: "https://twitch.tv")!) {
                        Image(url: "img/twitch.png", description: "Twitch")
                    }
                    .class("flex-none")
                    
                    HomepageDetails(title: "Square", subtitle: "iOS Engineering", link: URL(string: "https://squareup.com/us/en/point-of-sale/retail")!) {
                        Image(url: "img/square.png", description: "Square")
                    }
                    .class("flex-none")
                    
                    HomepageDetails(title: "Lickability", subtitle: "iOS Engineering", link: URL(string: "https://lickability.com")!) {
                        Image(url: "img/lickability.png", description: "Lickability")
                    }
                    .class("flex-none")
                    
                    HomepageDetails(title: "NYT Games", subtitle: "iOS Engineering", link: URL(string: "https://www.nytimes.com/crosswords")!) {
                        Image(url: "img/nytgames.png", description: "NYT Games")
                    }
                    .class("flex-none")
                }
                .class("flex justify-start gap-4 flex-wrap")
            }
            
            HomepageSection(title: "I produce charity gaming events.") {
                Div {
                    HomepageDetails(title: "Zeldathon", subtitle: "Broadcast Co-Lead", link: URL(string: "https://zeldathon.com")!) {
                        Image(url: "img/zeldathon.png", description: "Zeldathon")
                    }
                    .class("flex-none")
                    
                    HomepageDetails(title: "Minikit Marathon", subtitle: "Co-founder & Admin", link: URL(string: "https://twitch.tv/minikitmarathon")!) {
                        Image(url: "img/minikit.png", description: "Minikit Marathon")
                    }
                    .class("flex-none")
                }
                .class("flex justify-start gap-4 flex-wrap")
            }
            .class("bg-gray-200")
            
            HomepageSection(title: "I write about whatever tickles my fancy.") {
                for item in context.sections[.articles].items.prefix(5) {
                    Article {
                        Header {
                            H3 {
                                Link(item.title, url: item.path.absoluteString)
                            }
                            .class("text-slate-700")
                            
                            Div()
                                .class("border-b border-slate-300 flex-grow h-0")
                            
                            Span(item.date.formatted(Date.FormatStyle().month().year()))
                                .class("text-slate-500 font-light")
                        }
                         .class("flex justify-between items-center gap-4")
                        
                        Paragraph(item.metadata.summary)
                            .class("text-sm text-slate-500")
                    }
                }
            }
            
            HomepageSection(title: "I play a lot of video games.") {
                Div {
                    HomepagePoster(title: "Minecraft", link: URL(string: "https://minecraft.net/")!, imageURL: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/co49x5.png")!)
                    
                    HomepagePoster(title: "Slay the Spire", link: URL(string: "https://www.megacrit.com/")!, imageURL: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/co1iyf.png")!)
                    
                    HomepagePoster(title: "Tiny Tina's Wonderlands", link: URL(string: "https://playwonderlands.2k.com/")!, imageURL: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/co390m.png")!)
                    
                    HomepagePoster(title: "The Legend of Zelda: Tears of the Kingdom", link: URL(string: "https://zelda.com/tears-of-the-kingdom")!, imageURL: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/co5vmg.png")!)
                }
                .class("flex justify-between gap-4")
            }
            .class("bg-gray-200")
        }
        .document
    }
    
    func makeSectionHTML(for section: Section<GrantJButler>, context: PublishingContext<GrantJButler>) throws -> HTML {
        return MainLayout(context: context, location: section) {
            Container {
                H1(section.title)
                    .class("text-4xl font-bold mb-8")
                
                for (components, items) in section.items.chunked(onDate: \.date, calendar: context.dateFormatter.calendar) {
                    Node<Any>.element(named: "section", nodes: [
                        .component(
                            ComponentGroup {
                               FullWidthHeader(title: context.dateFormatter.calendar.date(from: components)!.formatted(Date.FormatStyle().month(.wide).year()))
                                
                                for item in items {
                                    Article {
                                        H3 {
                                            Link(item.title, url: item.path.absoluteString)
                                        }
                                        .class("text-lg font-medium")
                                        
                                        ItemDetails(item: item)
                                        
                                        Div {
                                            item.body
                                        }
                                        .class("prose")
                                    }
                                }
                            }
                            .class("relative")
                        )
                    ])
                }
            }
            .class("mb-8")
        }
        .document
    }
    
    func makeItemHTML(for item: Item<GrantJButler>, context: PublishingContext<GrantJButler>) throws -> HTML {
        MainLayout(context: context, location: item) {
            Container {
                Article {
                    H1(item.title)
                        .class("text-4xl font-bold mb-4")
                    
                    ItemDetails(item: item)
                    
                    Div {
                        item.body
                    }
                    .class("prose")
                }
            }
            .class("mb-8")
        }
        .document
    }
    
    func makePageHTML(for page: Page, context: PublishingContext<GrantJButler>) throws -> HTML {
        MainLayout(context: context, location: page) {
            Container {
                H1(page.title)
                    .class("text-4xl font-bold mb-8")
                
                page.body
            }
            .class("mb-8")
        }
        .document
    }
    
    func makeTagListHTML(for page: TagListPage, context: PublishingContext<GrantJButler>) throws -> HTML? {
        return HTML(head: [
            .meta(
                .attribute(named: "http-equiv", value: "refresh"),
                .attribute(named: "content", value: "0; url=/articles")
            )
        ], body: { })
//        MainLayout(context: context, location: page) {
//            Container {
//                H1(page.title)
//                    .class("text-4xl font-bold mb-8")
//                
//                for tag in page.tags.sorted(by: { $0.string < $1.string }) {
//                    TagComponent(tag: tag, size: .default)
//                }
//            }
//            .class("mb-8")
//        }
//        .document
    }
    
    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<GrantJButler>) throws -> HTML? {
        MainLayout(context: context, location: page) {
            Container {
                H1("#\(page.tag.string)")
                    .class("text-4xl font-bold mb-8")
                
                for (components, items) in context.items(taggedWith: page.tag).sorted(by: { $0.date > $1.date }).chunked(onDate: \.date, calendar: context.dateFormatter.calendar) {
                    Node<Any>.element(named: "section", nodes: [
                        .component(
                            ComponentGroup {
                                FullWidthHeader(title: context.dateFormatter.calendar.date(from: components)!.formatted(Date.FormatStyle().month(.wide).year()))
                                
                                for item in items {
                                    Article {
                                        H3 {
                                            Link(item.title, url: item.path.absoluteString)
                                        }
                                        .class("text-slate-700")
                                        
                                        Paragraph(item.metadata.summary)
                                            .class("text-sm text-slate-500")
                                    }
                                }
                            }
                            .class("relative")
                        )
                    ])
                }
            }
            .class("mb-8")
        }
        .document
    }
}

private struct SiteHeader<Site: Website>: Component {
    let context: PublishingContext<Site>

    var body: Component {
        Header {
            Div {
                H1 {
                    Link("Grant J Butler", url: "/")
                }
                .class("text-2xl font-semibold")
                
                Navigation {
                    Div {
                        for section in context.sections {
                            Link(section.title, url: section.path.absoluteString)
                                .class("font-medium text-gray-500 hover:text-gray-600")
                        }
                    }
                    .class("flex gap-2")
                    
                    Div {
                        Link(url: URL(string: "https://github.com/grantjbutler")!) {
                            Node<Any>.SVG.github
                                .class("w-4 h-4 fill-current text-gray-400 hover:text-gray-500")
                        }
                        
                        Link(url: URL(string: "https://hachyderm.io/@grantjbutler")!) {
                            Node<Any>.SVG.mastodon
                                .class("w-4 h-4 fill-current text-gray-400 hover:text-gray-500")
                        }
                        
                        Link(url: "/feed.rss") {
                            Node<Any>.SVG.rss
                                .class("w-4 h-4 fill-current text-gray-400 hover:text-gray-500")
                        }
                    }
                    .class("flex gap-2")
                }
                .class("flex gap-4 items-center")
            }
            .class("flex justify-between items-baseline px-4 sm:px-2 py-3 border-b border-gray-400 container mx-auto lg:max-w-[1024px]")
        }
        .class("bg-gray-100/40 backdrop-blur-md fixed w-full")
    }
}

private struct SiteFooter: Component {
    var body: Component {
        Footer {
            Container {
                Paragraph("&copy; 2023 Grant J Butler")
                    .class("text-center text-sm")
            }
        }
        .class("bg-gray-300 py-6 text-gray-500")
    }
}

private struct Container: Component {
    @ComponentBuilder
    let content: () -> Component
    
    var body: Component {
        Div {
            Div {
                content()
            }
            .class("container mx-auto px-4 sm:px-0 md:max-w-[768px]")
        }
    }
}

private struct MainLayout<Site: Website> {
    let context: PublishingContext<Site>
    let location: Location
    
    @ComponentBuilder
    let bodyClosure: () -> Plot.Component
    
    var document: HTML {
        HTML(
            .lang(context.site.language),
            .head(for: location, on: context.site),
            .body(
                .class("bg-gray-100 text-slate-900"),
                .component(SiteHeader(context: context)),
                .div(
                    .class("pt-24"),
                    bodyClosure().convertToNode()
                ),
                .component(SiteFooter())
            )
        )
    }
}

private struct HomepageSection: Component {
    let title: String

    @ComponentBuilder
    let content: () -> Component
    
    var body: Component {
        Container {
            Article {
                H2(title)
                    .class("text-2xl text-slate-700 mb-4 font-semibold")
                    
                Div {
                    content()
                }
            }
            .class("py-6")
        }
    }
}

private struct HomepageDetails: Component {
    let title: String
    let subtitle: String
    let link: URL
    
    @ComponentBuilder
    let image: () -> Component
    
    var body: Component {
        Div {
            image()
                .class("w-16 h-16 rounded-xl shadow")
        
            Div {
                H3 {
                    Link(title, url: link)
                }
                .class("font-medium underline")
                
                H4(subtitle)
                    .class("text-sm text-slate-700")
            }
        }
        .class("flex items-center gap-2")
    }
}

private struct HomepagePoster: Component {
    let title: String
    let link: URL
    let imageURL: URL

    var body: Component {
        Div {
            Image(url: imageURL, description: title)
                .class("rounded shadow")
            
            H3 {
                Link(title, url: link)
            }
            .class("underline text-sm text-slate-700")
        }
        .class("w-1/4 flex flex-col gap-2")
    }
}

private struct ItemDetails: Component {
    let item: Item<GrantJButler>
    
    var body: Component {
        Div {
            Div {
                Time(datetime: item.date.formatted()) {
                    Span(item.date.formatted(date: .abbreviated, time: .omitted))
                }
                
                Node<Any>.raw("&mdash;")
                
                Span(DateComponentsFormatter.localizedString(from: DateComponents(minute: item.readingTime.minutes), unitsStyle: .short)!)
            }
            .class("text-slate-500 text-sm mb-1")
            
            for tag in item.tags {
                TagComponent(tag: tag, size: .small)
            }
        }
        .class("mb-3")
    }
}

private struct FullWidthHeader: Component {
    let title: String

    var body: Component {
        Div {
            H2(title)
                .class("isolate w-fit px-2 text-xl text-slate-400 font-semibold text-center bg-gray-100 z-10")
        }
        .class("flex justify-center items-center mb-4 before:border-b before:border-gray-300 before:h-0 before:w-full before:content-['_'] before:absolute before:top-1/2 before:left-0 before:z-0")
    }
}

private struct TagComponent: Component {
    enum Size {
        case small
        case `default`
        
        var classes: String {
            switch self {
            case .small:
                return "text-xs rounded-sm"
            case .default:
                return "text-sm rounded"
            }
        }
    }
    
    let tag: Tag
    let size: Size
    
    var body: Component {
        Link("#\(tag.string)", url: "/tags/\(tag.normalizedString())")
            .class("bg-blue-100 text-blue-500 py-1 px-2")
            .class(size.classes)
    }
}

private extension Collection {
    func chunked(onDate getter: (Element) -> Date, calendar: Calendar) -> [(DateComponents, SubSequence)] {
        return self.chunked { item in
            calendar.dateComponents([.month, .year], from: getter(item))
        }.sorted(by: { lhs, rhs in
            if lhs.0.year == rhs.0.year {
                return lhs.0.month! > rhs.0.year!
            } else {
                return lhs.0.year! > rhs.0.year!
            }
        })
    }
}
