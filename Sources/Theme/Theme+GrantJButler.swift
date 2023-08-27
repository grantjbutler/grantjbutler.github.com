import Foundation
import Plot
import Publish

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
        MainLayout(context: context, location: section) {
            Container {
                H1(section.title)
                    .class("text-4xl font-bold")
                
                for item in section.items {
                    Paragraph(item.title)
                }
            }
        }
        .document
    }
    
    func makeItemHTML(for item: Item<GrantJButler>, context: PublishingContext<GrantJButler>) throws -> HTML {
        MainLayout(context: context, location: item) {
            Container {
                H1(item.title)
                    .class("text-4xl font-bold")
            }
        }
        .document
    }
    
    func makePageHTML(for page: Page, context: PublishingContext<GrantJButler>) throws -> HTML {
        MainLayout(context: context, location: page) {
            Container {
                H1(page.title)
                    .class("text-4xl font-bold")
            }
        }
        .document
    }
    
    func makeTagListHTML(for page: TagListPage, context: PublishingContext<GrantJButler>) throws -> HTML? {
        MainLayout(context: context, location: page) {
            Container {
                H1(page.title)
                    .class("text-4xl font-bold")
            }
        }
        .document
    }
    
    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<GrantJButler>) throws -> HTML? {
        MainLayout(context: context, location: page) {
            Container {
                H1(page.tag.string)
                    .class("text-4xl font-bold")
            }
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
                    }
                    .class("flex gap-2")
                }
                .class("flex gap-4 items-center")
            }
            .class("flex justify-between items-baseline px-4 sm:px-2 py-3 border-b border-gray-400 container mx-auto lg:max-w-[1024px]")
        }
        .class("backdrop-blur-md fixed w-full")
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
            content()
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
