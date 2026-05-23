import Foundation
import Plot
import Publish

struct ItemDetails: Component {
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
