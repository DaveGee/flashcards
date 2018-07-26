import XCTest
@testable import Flashcard

class MainUseCaseTests: XCTestCase {
    
    var sut: MainUseCase!
    var card: Card!
    
    override func setUp() {
        sut = MainUseCase()
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
}
