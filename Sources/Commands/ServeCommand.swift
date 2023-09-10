import ArgumentParser
import Foundation
import ShellOut

struct Serve: AsyncParsableCommand {
    @Flag(help: "Watch for file changes and regenerate the website as a result.")
    var watch: Bool = false
    
    @Option(help: "The port on which to run the server.")
    var port = 8000
    
    func run() async throws {
        print("Performing initial generation of the site")
        
        try generateSite(isDeploy: false)
    
        let outputURL = try GrantJButler.findRoot().appending(path: "Output", directoryHint: .isDirectory)
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            let serverProcess = Process()
            
            group.addTask {
                do {
                    _ = try shellOut(
                        to: "python3 -m http.server \(self.port)",
                        at: outputURL.path(percentEncoded: false),
                        process: serverProcess
                    )
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            if watch {
                group.addTask {
                    try await Watch().run()
                }
            }
            
            group.addTask {
                _ = readLine()
            }
            
            try await group.next()
            
            group.cancelAll()
        }
    }
}
