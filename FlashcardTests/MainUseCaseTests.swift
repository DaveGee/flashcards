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
