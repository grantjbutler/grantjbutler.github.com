import Foundation
import Plot
import Publish

struct HomepagePoster: Component {
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
        .class("sm:w-1/4 flex flex-col gap-2")
    }
}
