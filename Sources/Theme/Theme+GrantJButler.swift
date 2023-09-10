import Algorithms
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
                for item in context.sections[.articles].items.reversed().prefix(5) {
                    Article {
                        Header {
                            H3 {
                                Link(item.title, url: item.path.absoluteString)
                            }
                            .class("text-slate-700")
                            
                            Div()
                                .class("border-b border-slate-300 flex-grow h-0 hidden sm:block")
                            
                            Span(item.date.formatted(Date.FormatStyle().month().year()))
                                .class("text-slate-500 font-light flex-none")
                        }
                        .class("flex justify-between items-start sm:items-center gap-4")
                        
                        Paragraph(item.metadata.summary)
                            .class("text-sm text-slate-500")
                    }
                    .class("mb-2 last:mb-0")
                }
            }
            
            HomepageSection(title: "I play a lot of video games.") {
                Div {
                    HomepagePoster(title: "Minecraft", link: URL(string: "https://minecraft.net/")!, imageURL: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/co49x5.png")!)
                    
                    HomepagePoster(title: "Slay the Spire", link: URL(string: "https://www.megacrit.com/")!, imageURL: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/co1iyf.png")!)
                    
                    HomepagePoster(title: "Tiny Tina's Wonderlands", link: URL(string: "https://playwonderlands.2k.com/")!, imageURL: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/co390m.png")!)
                    
                    HomepagePoster(title: "The Legend of Zelda: Tears of the Kingdom", link: URL(string: "https://zelda.com/tears-of-the-kingdom")!, imageURL: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/co5vmg.png")!)
                }
                .class("grid grid-cols-2 sm:grid-cols-none sm:flex sm:justify-between gap-4")
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
                
                for (components, items) in section.items.reversed().chunked(onDate: \.date, calendar: context.dateFormatter.calendar) {
                    Node<Any>.element(named: "section", nodes: [
                        .attribute(named: "class", value: "mb-8"),
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
                                        .class("prose max-w-none")
                                    }
                                }
                            }
                        )
                    ])
                }
            }
            .class("mb-8")
        }
        .document
    }
    
    func makeItemHTML(for item: Item<GrantJButler>, context: PublishingContext<GrantJButler>) throws -> HTML {
        return MainLayout(context: context, location: item) {
            Container {
                Article {
                    H1(item.title)
                        .class("text-4xl font-bold mb-4")
                    
                    ItemDetails(item: item)
                    
                    Div {
                        item.body
                    }
                    .class("prose max-w-none")
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
        return nil
    }
    
    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<GrantJButler>) throws -> HTML? {
        MainLayout(context: context, location: page) {
            Container {
                H1("#\(page.tag.string)")
                    .class("text-4xl font-bold mb-8")
                
                for (components, items) in context.chunkedItems(taggedWith: page.tag) {
                    Node<Any>.element(named: "section", nodes: [
                        .attribute(named: "class", value: "mb-8"),
                        .component(
                            ComponentGroup {
                                FullWidthHeader(title: context.dateFormatter.calendar.date(from: components)!.formatted(Date.FormatStyle().month(.wide).year()))
                                
                                for item in items {
                                    Article {
                                        H3 {
                                            Link(item.title, url: item.path.absoluteString)
                                        }
                                        .class("text-slate-700 font-medium")
                                        
                                        Paragraph(item.metadata.summary)
                                            .class("text-sm text-slate-500")
                                    }
                                }
                            }
                        )
                    ])
                }
            }
            .class("mb-8")
        }
        .document
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

extension PublishingContext where Site == GrantJButler {
    func chunkedItems(taggedWith tag: Tag) -> [(DateComponents, ArraySlice<Item<GrantJButler>>)] {
        return items(taggedWith: tag)
            .sorted(by: { $0.date > $1.date })
            .chunked(onDate: \.date, calendar: .current)
    }
}
