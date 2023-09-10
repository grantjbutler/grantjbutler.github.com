import Foundation
import Plot
import Publish

struct SiteHeader<Site: Website>: Component {
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
                        .linkRelationship("me")
                        
                        Link(url: Path.defaultForRSSFeed.absoluteString) {
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
        .class("bg-gray-100/[.65] backdrop-blur-md fixed w-full z-50")
    }
}
