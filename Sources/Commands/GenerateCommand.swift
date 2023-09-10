import ArgumentParser

struct Generate: ParsableCommand {
    @Flag(help: "Perform a deploy of the generated website.")
    var deploy: Bool = false
    
    func run() throws {
        try generateSite(isDeploy: deploy)
    }
}
