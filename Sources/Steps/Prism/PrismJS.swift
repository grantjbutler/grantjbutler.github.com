import Foundation
import JavaScriptCore
import os

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
        context.exceptionHandler = { context, value in
            print("Received JavaScript exception: \(value)")
        }
        
        context.setObject(JSConsole(), forKeyedSubscript: "console" as NSString)
        
        context.evaluateScript("window = {}; window.Prism = {}; window.Prism.manual = true; window.Prism.plugins = 'diff-highlight,line-highlight'")
        context.evaluateScript(Self.prismSourceCode)
    }
    
    func highlight(_ code: String, language: String) -> String {
        let grammar: JSValue
        if language.hasPrefix("diff-") {
            grammar = self.language(named: "diff")
        } else {
            grammar = self.language(named: language)
        }
        
        let highlightedCode = context.objectForKeyedSubscript("Prism")
            .objectForKeyedSubscript("highlight")
            .call(withArguments: [code, grammar, language])!
        return highlightedCode.toString()
    }
    
    func language(named name: String) -> JSValue {
        context.objectForKeyedSubscript("Prism")
            .objectForKeyedSubscript("languages")
            .objectForKeyedSubscript(name)!
    }
    
    func isLanguageSupport(_ language: String) -> Bool {
        var language = language
        if language.hasPrefix("diff-") {
            language = "diff"
        }
        return languages.contains(language)
    }
    
    private var languages: some Collection<String> {
        let languages = context.objectForKeyedSubscript("Prism")
            .objectForKeyedSubscript("languages")!
        return (languages.toObject() as! Dictionary<String, Any>).keys
    }
}

private protocol ConsoleExport: JSExport {
    func log()
    func debug()
    func error()
    func exception()
    func info()
    func warn()
}

private final class JSConsole: NSObject, ConsoleExport {
    private let logger = Logger(subsystem: "javascript", category: "console")
    
    func log() {
        _log(.default, JSContext.currentArguments())
    }
    
    func debug() {
        _log(.debug, JSContext.currentArguments())
    }
    
    func error() {
        _log(.error, JSContext.currentArguments())
    }
    
    func exception() {
        _log(.error, JSContext.currentArguments())
    }
    
    func info() {
        _log(.info, JSContext.currentArguments())
    }
    
    func warn() {
        _log(.default, JSContext.currentArguments())
    }
    
    private func _log(_ level: OSLogType, _ arguments: [Any]) {
        let stringRepresentations = arguments.map { "\($0)" }
        let string: String = stringRepresentations.joined(separator: ", ")
        logger.log("\(string, privacy: .public)")
    }
}
