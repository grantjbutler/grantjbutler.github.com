import ArgumentParser

@main
struct Generator: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A static site generator ",
        subcommands: [Generate.self, Watch.self, Serve.self],
        defaultSubcommand: Generate.self
    )
}
