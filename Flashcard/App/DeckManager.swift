import Foundation

enum DeckError: Error {
    case emptyDeck
}

class DeckManager {
    private var deck = [Card]()
    
    static var shared = DeckManager()
    
    var countCards: Int {
        return deck.count
    }
    
    func add(card: Card) {
        deck.append(card)
    }
    
    func cards() -> [Card] {
        return deck
    }
    
    func draw() throws -> Card {
        if deck.count <= 0 {
            throw DeckError.emptyDeck
        }
        
        return deck[0]
    }
}
