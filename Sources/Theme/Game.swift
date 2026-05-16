import Foundation

struct Game {
    let name: String
    let url: URL
    let posterURL: URL
    
    static let all: [Game] = [
        .slayTheSpire2,
        .borderlands4,
        .minecraft,
        .planetCrafter,
        .raft,
        .tr49,
    ]
}

extension Game {
    static let borderlands3 = Game(
        name: "Borderlands 3",
        url: URL(string: "https://borderlands.2k.com/borderlands-3/")!,
        posterURL: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/co20r3.png")!
    )
    
    static let borderlands4 = Game(
        name: "Borderlands 4",
        url: URL(string: "https://borderlands.2k.com/borderlands-4/")!,
        posterURL: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/co9zuq.png")!
    )
    
    static let minecraft = Game(
        name: "Minecraft",
        url: URL(string: "https://minecraft.net/")!,
        posterURL: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/co49x5.png")!
    )
    
    static let planetCrafter = Game(
        name: "The Planet Crafter",
        url: URL(string: "https://mijugames.com")!,
        posterURL: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/coaaw4.png")!
    )
    
    static let raft = Game(
        name: "Raft",
        url: URL(string: "https://www.raft-game.com")!,
        posterURL: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/co1xdc.png")!
    )
    
    static let slayTheSpire = Game(
        name: "Slay the Spire",
        url: URL(string: "https://www.megacrit.com/")!,
        posterURL: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/co1iyf.png")!
    )
    
    static let slayTheSpire2 = Game(
        name: "Slay the Spire II",
        url: URL(string: "https://www.megacrit.com/")!,
        posterURL: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/co82c5.png")!
    )
    
    static let tinyTinasWonderlands = Game(
        name: "Tiny Tina's Wonderlands",
        url: URL(string: "https://playwonderlands.2k.com/")!,
        posterURL: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/co390m.png")!
    )
    
    static let tr49 = Game(
        name: "TR-49",
        url: URL(string: "https://www.inklestudios.com/tr-49/")!,
        posterURL: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/coaw0w.png")!
    )
}

extension HomepagePoster {
    init(_ game: Game) {
        self.init(title: game.name, link: game.url, imageURL: game.posterURL)
    }
}
