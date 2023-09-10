import Foundation
import JavaScriptCore

public struct PrismJS {
    let context = JSContext()!
    
    private static var _prismSourceCode: String?
    private static var prismSourceCode: String? {
        if let _prismSourceCode { return _prismSourceCode }
        _prismSourceCode = loadSourceCode()
        return _prismSourceCode!
    }
    
    private static func loadSourceCode() -> String {
        let sourceCodeLocation = URL(filePath: #filePath).deletingLastPathComponent().appending(path: "prism.js", directoryHint: .notDirectory)
        return try! String(contentsOf: sourceCodeLocation)
    }
    
    init() {
        context.evaluateScript("window = {}; window.Prism = {}; window.Prism.manual = true;")
        context.evaluateScript(Self.prismSourceCode)
    }
    
    func highlight(_ code: String, language: String) -> String {
        let highlightedCode = context.objectForKeyedSubscript("Prism")
            .objectForKeyedSubscript("highlight")
            .call(withArguments: [code, self.language(named: language), language])!
        return highlightedCode.toString()
    }
    
    func language(named name: String) -> JSValue {
        context.objectForKeyedSubscript("Prism")
            .objectForKeyedSubscript("languages")
            .objectForKeyedSubscript(name)!
    }
    
    var languages: some Collection<String> {
        let languages = context.objectForKeyedSubscript("Prism")
            .objectForKeyedSubscript("languages")!
        return (languages.toObject() as! Dictionary<String, Any>).keys
    }
}
