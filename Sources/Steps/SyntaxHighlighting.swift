import Ink
import Publish

extension PublishingStep {
    static func highlightSyntax() -> Self {
        return .step(named: "Highlight Syntax") { context in
            context.markdownParser.addModifier(.prism)
        }
    }
}

private extension Modifier {
    static var prism: Self {
        let prism = PrismJS()
    
        return .init(target: .codeBlocks) { html, markdown in
            let openingMarks = markdown.components(separatedBy: .newlines).first ?? "```"
            let languageComponents = String(openingMarks.dropFirst("```".count))
            
            let components = languageComponents.split(separator: ",")
            let language = String(components[0])
            
            guard language != "no-language" && !language.isEmpty else {
                return html
            }
            
            guard prism.isLanguageSupport(language) else {
                print("Unsupported language \(language)")
                return html
            }
            
            let code = markdown
                .dropFirst()
                .drop(while: { !$0.isNewline })
                .dropLast("\n```".count)
            
            let highlightedCode = prism.highlight(String(code), language: language).trimmingCharacters(in: .newlines)
            return "<pre><code class=\"language-\(language)\">\(highlightedCode)</code></pre>"
        }
    }
}
