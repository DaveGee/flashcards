import XCTest
@testable import Flashcard

class MainUseCaseTests: XCTestCase {
    
    var sut: MainUseCase!
    
    override func setUp() {
        sut = MainUseCase()
        sut.authProxy = AnonymousAuthStub()
        sut.storeProxy = FirestoreStub()
    }
    
    func testHas0CardsInitially() {
        XCTAssertEqual(sut.countCards, 0)
    }
    
    func testHasSharedInstance() {
        XCTAssertNotNil(MainUseCase.shared)
    }
    
    func testCanAuthAnonymously() {
        let loginExpectation = expectation(description: "Logged in anonymously")
        sut.authProxy = AnonymousAuthStub()
        
        sut.auth {
            guard let user = self.sut.user else {
                XCTFail("User nil")
                return
            }
            XCTAssertTrue(user.isAnonymous)
            XCTAssertEqual(user.uid, "anonymousUserId")
            loginExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testFailedAuth() {
        let failExpectation = expectation(description: "Failed auth")
        sut.authProxy = FailAuthStub()
        
        sut.auth {
            XCTAssertNil(self.sut.user)
            failExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testGetsSomeCards() {
        let cardExpectations = expectation(description: "Cards")
        let remoteCards = [Card(recto: "1", verso: "1", owner: "o"), Card(recto: "2", verso: "2", owner: "0")]
        sut.storeProxy = FirestoreStub(cards: remoteCards)
        
        sut.loadCards {
            let cards = self.sut.cards()
            XCTAssertEqual(cards.count, remoteCards.count)
            cardExpectations.fulfill()
        }
        
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testCannotSaveCardWithoutLogin() {
        let saveExpectation = expectation(description: "Saved")
        saveExpectation.isInverted = true
        
        let stub = FirestoreStub()
        sut.storeProxy = stub
        
        XCTAssertThrowsError(
            try sut.createCard(recto: "r", verso: "v") {}
        )
        
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testSaveCardToTheCloud() {
        let saveExpectation = expectation(description: "Saved")
        let stub = FirestoreStub()
        sut.storeProxy = stub
        sut.auth {}
        
        do {
            try sut.createCard(recto: "r", verso: "v") {
                XCTAssertNotNil(stub.lastSavedCard)
                let cards = self.sut.cards()
                XCTAssertEqual(cards.count, 1)
                XCTAssertEqual(cards[0].recto, "r")
                XCTAssertEqual(cards[0].owner, "anonymousUserId")
                saveExpectation.fulfill()
            }
        } catch {
            XCTFail()
        }
        
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testDrawFromEmptyDeckDontFail() {
        sut.auth {}
        
        let card = try! sut.drawNext()
        XCTAssertNil(card)
    }
    
    func testDrawWithoutAuthThrows() {
        XCTAssertThrowsError(try sut.drawNext()) { (error) in
            XCTAssertEqual(error as! DeckError, DeckError.invalidUser)
        }
    }
    
    func testDraw1From1CardDeck() {
        sut.auth {}
        
        addCardsToStore()
        guard let drawn = try! self.sut.drawNext() else {
            XCTFail()
            return
        }
        
        XCTAssertNotNil(drawn)
        XCTAssertEqual(drawn.recto, "0")
        XCTAssertEqual(drawn.verso, "0")
    }
    
    func testDrawIncrementsCardStat() {
        sut.auth {}
        
        addCardsToStore()
        XCTAssertEqual(sut.cards()[0].stat(.draw), 0)
        
        let firstDraw = try! self.sut.drawNext()
        XCTAssertEqual(firstDraw?.stat(.draw), 1)
        
        let secondDraw = try! self.sut.drawNext()
        XCTAssertEqual(secondDraw?.stat(.draw), 2)
    }
    
    func testDrawsAllCardUniformly() {
        sut.auth {}
        addCardsToStore(num: 2)
        
        let result = (1...10).reduce([String: Int]()) { (dict, i) in
            var dict = dict
            let card = try! self.sut.drawNext()
            let cardLabel = card?.recto ?? "nil"
            dict[cardLabel, default: 0] += 1
            return dict
        }
        
        XCTAssertNil(result["nil"])
        XCTAssertEqual(result["0"], result["1"])
    }
    
    func addCardsToStore(num: Int = 1) {
        let group = DispatchGroup()
        
        for i in 0..<num {
            group.enter()
            try! sut.createCard(recto: "\(i)", verso: "\(i)") {
                group.leave()
            }
        }
        
        group.wait()
    }
}

// --- STUBS

class AnonymousAuthStub: AuthGateway {
    func authAnonymously(completion: @escaping (User?) -> Void) {
        let user = User(uid: "anonymousUserId", isAnonymous: true)
        completion(user)
    }
}

class FailAuthStub: AuthGateway {
    func authAnonymously(completion: @escaping (User?) -> Void) {
        completion(nil)
    }
}

class FirestoreStub: FirestoreGateway {
    var cards: [Card]
    private(set) var lastSavedCard: Card? = nil
    
    convenience init() {
        self.init(cards: [Card]())
    }
    
    init(cards: [Card]) {
        self.cards = cards
    }
    
    func fetchCards(completion: @escaping ([Card]) -> Void) {
        completion(self.cards)
    }
    
    func save(card: Card, completion: @escaping () -> Void) {
        self.lastSavedCard = card
        self.fetchCards { _ in
            self.cards.append(card)
            completion()
        }
    }
}
