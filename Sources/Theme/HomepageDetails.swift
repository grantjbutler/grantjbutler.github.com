import Foundation
import Plot
import Publish

struct HomepageDetails: Component {
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
