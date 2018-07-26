enum DeckError: Error {
    case emptyDeck
}

class MainUseCase {
    static var shared = MainUseCase()
    
    lazy var authProxy: AuthGateway = AuthGatewayFirebase()
    
    private(set) var user: User? = nil
    
    private var deck = [Card]()
    
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
    
    func auth(completion: @escaping () -> Void) {
        authProxy.authAnonymously { user in
            self.user = user
            completion()
        }
    }
}
