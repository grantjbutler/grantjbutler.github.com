import ArgumentParser
import FileWatcher
import Foundation
import ShellOut

struct Watch: AsyncParsableCommand {
    func run() async throws {
        let packageRoot = try GrantJButler.findRoot()
        
        let sourcesURL = packageRoot.appending(path: "Sources", directoryHint: .isDirectory)
        let contentURL = packageRoot.appending(path: "Content", directoryHint: .isDirectory)
    
        let watcher = FileWatcher([
            sourcesURL.path(percentEncoded: false),
            contentURL.path(percentEncoded: false)
        ])
        
        let stream = AsyncStream(FileWatcherEvent.self) { continuation in
            watcher.callback = { event in
                continuation.yield(event)
            }
            
            continuation.onTermination = { _ in
                watcher.stop()
            }
            
            watcher.start()
        }
        
        for await event in stream {
            do {
                let watchedFileURL = URL(filePath: event.path)
                if watchedFileURL.isContained(in: sourcesURL) {
                    print("Rebuilding project due to changes in \(watchedFileURL)")
                
                    do {
                        try shellOut(
                            to: .buildSwiftPackage(),
                            at: packageRoot.path(percentEncoded: false)
                        )
                    } catch {
                        throw WatchError.rebuild(error)
                    }
                }
                
                do {
                    print("Regenerating website due to changes in \(watchedFileURL)")
                
                    try shellOut(
                        to: "swift run",
                        at: packageRoot.path(percentEncoded: false)
                    )
                } catch {
                    throw WatchError.regenerate(error)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

private enum WatchError: LocalizedError, CustomStringConvertible, CustomDebugStringConvertible {
    case rebuild(Error)
    case regenerate(Error)
    
    var localizedDescription: String {
        switch self {
        case let .rebuild(error):
            return "[Rebuild] \(error.localizedDescription)"
        case let .regenerate(error):
            return "[Regenerate] \(error.localizedDescription)"
        }
    }
    
    var errorDescription: String? {
        localizedDescription
    }
    
    var description: String {
        localizedDescription
    }
    
    var debugDescription: String {
        var description = ""
        
        switch self {
        case let .rebuild(error):
            dump(error, to: &description, name: "Rebuild error")
        case let .regenerate(error):
            dump(error, to: &description, name: "Regenerate error")
        }
        
        return description
    }
}

private extension URL {
    func isContained(in other: URL) -> Bool {
        var copy = self
        
        while copy.pathComponents.count > other.pathComponents.count {
            copy = copy.deletingLastPathComponent()
        }
        
        return copy == other
    }
}
