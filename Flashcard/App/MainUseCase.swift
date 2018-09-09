enum DeckError: Error {
    case invalidUser
}

class MainUseCase {
    static var shared = MainUseCase()
    
    convenience init(user: User?) {
        self.init()
        self.user = user
    }
    
    lazy var authProxy: AuthGateway = AuthGatewayFirebase()
    lazy var storeProxy: FirestoreGateway = FirestoreDB()
    
    private(set) var user: User? = nil
    
    private var deck = [Card]()
    
    var countCards: Int {
        return deck.count
    }
    
    func createCard(recto: String, verso: String, completion: @escaping () -> Void) throws {
        guard let user = self.user else {
            throw DeckError.invalidUser
        }
        
        let card = Card(recto: recto, verso: verso, owner: user.uid)
        
        storeProxy.save(card: card) {
            self.loadCards {
                completion()
            }
        }
    }

    func update(card: Card) {
        if card.id != nil {
            storeProxy.save(card: card) {}
        }
    }
    
    func cards() -> [Card] {
        return deck
    }
    
    func auth(completion: @escaping () -> Void) {
        authProxy.authAnonymously { user in
            self.user = user
            completion()
        }
    }
    
    func loadCards(completion: @escaping () -> Void) {
        storeProxy.fetchCards { (cards) in
            self.deck = cards
            completion()
        }
    }
    
    func drawNext() throws -> Card? {
        guard self.user != nil else {
            throw DeckError.invalidUser
        }
        
        if countCards == 0 {
            return nil
        }
        
        if let drawn = getLessDrawn() {
            drawn.updateStat(.draw)
            update(card: drawn)
            return drawn
        } else {
            return nil
        }
    }
    
    private func getLessDrawn() -> Card? {
        return deck.min { $0.stat(.draw) < $1.stat(.draw) }
    }
}
