enum DeckError: Error {
    case emptyDeck
    case noUser
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
            throw DeckError.noUser
        }
        
        let card = Card(recto: recto, verso: verso, owner: user.uid)
        
        storeProxy.save(card: card) {
            self.loadCards {
                completion()
            }
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
}
