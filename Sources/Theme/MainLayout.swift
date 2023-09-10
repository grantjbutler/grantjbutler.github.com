import Foundation
import Publish
import Plot

struct MainLayout<Site: Website> {
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
