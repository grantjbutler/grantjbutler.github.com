import Foundation
import Plot
import Publish
import UniformTypeIdentifiers

struct GrantJButler: Website {
    enum SectionID: String, WebsiteSectionID {
        case articles
    }
    
    struct ItemMetadata: WebsiteItemMetadata {
        
    }

    var name: String = "Grant J Butler"
    var description: String = ""
    var url: URL = URL(string: "https://grantjbutler.com/")!
    var language: Plot.Language { .english }
    var imagePath: Publish.Path? { nil }
}

extension GrantJButler {
    static func findRoot() throws -> URL {
        var fileURL = URL(filePath: #file)
        while fileURL != URL(filePath: "/") {
            fileURL = fileURL.deletingLastPathComponent()
            
            let packageURL = fileURL.appendingPathComponent("Package", conformingTo: .swiftSource)
            
            if FileManager.default.fileExists(atPath: packageURL.path(percentEncoded: false)) {
                return fileURL
            }
        }
        
        throw URLError(.fileDoesNotExist)
    }
}
