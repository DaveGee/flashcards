import Foundation

class CardRepository {
    var countCards: Int {
        return self.cards.count
    }
    
    private var cards = [Card]()
    
    func add(card: Card) {
        cards.append(card)
    }
    
    func card(atIndex index: Int) -> Card {
        return cards[index]
    }
}
