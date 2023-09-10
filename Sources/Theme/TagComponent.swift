import Plot
import Publish

struct TagComponent: Component {
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
