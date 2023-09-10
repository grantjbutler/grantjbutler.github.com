import Plot
import Publish

struct FullWidthHeader: Component {
    let title: String

    var body: Component {
        Div {
            H2(title)
                .class("isolate w-fit px-2 text-xl text-slate-400 font-semibold text-center bg-gray-100 z-10")
        }
        .class("flex justify-center items-center mb-4 before:border-b before:border-gray-300 before:h-0 before:w-full before:content-['_'] before:absolute before:top-1/2 before:left-0 before:z-0 relative")
    }
}
