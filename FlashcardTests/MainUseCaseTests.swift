import XCTest
@testable import Flashcard

class MainUseCaseTests: XCTestCase {
    
    var sut: MainUseCase!
    var card: Card!
    
    override func setUp() {
        sut = MainUseCase()
        sut.authProxy = AnonymousAuthStub()
        
        card = Card(recto: "recto", verso: "verso")
    }
    
    func testHas0CardsInitially() {
        XCTAssert(sut.countCards == 0)
    }
    
    func testCanAddACard() {
        sut.add(card: card)
        
        XCTAssert(sut.countCards == 1)
    }
    
    func testRemembersCardsAdded() {
        let secondCard = Card(recto: "2", verso: "2")
        sut.add(card: card)
        sut.add(card: secondCard)
        
        let cards = sut.cards()
        
        XCTAssert(sut.countCards == 2)
        XCTAssert(cards.count == 2)
        XCTAssert(cards.contains(card))
        XCTAssert(cards.contains(secondCard))
    }
    
    func testManagerCannotDrawFromEmptyDeck() {
        XCTAssertThrowsError(try sut.draw()) { (error) in
            XCTAssertEqual(error as? DeckError, DeckError.emptyDeck)
        }
    }
    
    func testCanDrawCard() {
        sut.add(card: card)
        
        XCTAssertNotNil(try sut.draw())
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
            XCTAssert(user.uid == "anonymousUserId")
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
}

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
