import Plot
import Publish

struct SiteFooter: Component {
    var body: Component {
        Footer {
            Container {
                Paragraph("&copy; 2023 Grant J Butler")
                    .class("text-center text-sm")
            }
        }
        .class("bg-gray-300 py-6 text-gray-500")
    }
}
