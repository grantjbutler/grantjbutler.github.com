import Foundation
import Plot
import Publish
import UniformTypeIdentifiers

struct GrantJButler: Website {
    enum SectionID: String, WebsiteSectionID {
        case articles
    }
    
    struct ItemMetadata: WebsiteItemMetadata {
        let summary: String
        let draft: Bool
        let publishDate: Date
        
        enum CodingKeys: String, CodingKey {
            case summary
            case draft
            case publishDate = "publish_date"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.summary = try container.decode(String.self, forKey: .summary)
            self.draft = try container.decodeIfPresent(Bool.self, forKey: .draft) ?? false
            
            let pacificTimeZone = TimeZone(identifier: "America/Los_Angeles")!
            
            let strategy = Date.ParseStrategy(format: "\(year: .defaultDigits)-\(month: .defaultDigits)-\(day: .defaultDigits)", timeZone: pacificTimeZone)
            let date = try Date(try container.decode(String.self, forKey: .publishDate), strategy: strategy)
            
            var calendar = Calendar.current
            calendar.timeZone = pacificTimeZone
            
            guard let publishDate = calendar.date(bySettingHour: 9, minute: 41, second: 00, of: date) else {
                throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath + [CodingKeys.publishDate], debugDescription: "Could not set time for publish date"))
            }
            
            self.publishDate = publishDate
        }
    }

    var name: String = "Grant J Butler"
    var description: String = ""
    var url: URL = URL(string: "https://grantjbutler.com/")!
    var language: Plot.Language { .english }
    var imagePath: Publish.Path? { nil }
    
    let isDeploy: Bool
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
