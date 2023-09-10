import Foundation
import Plot
import Publish
import ReadingTimePublishPlugin

struct HomepageSection: Component {
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
