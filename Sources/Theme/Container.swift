import Plot
import Publish

struct Container: Component {
    @ComponentBuilder
    let content: () -> Component
    
    var body: Component {
        Div {
            Div {
                content()
            }
            .class("container mx-auto px-4 lg:max-w-[1024px]")
        }
    }
}
