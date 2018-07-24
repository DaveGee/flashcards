import XCTest
@testable import Flashcard

class DeckManagerTests: XCTestCase {
    
    var manager: DeckManager!
    var card: Card!
    
    override func setUp() {
        manager = DeckManager()
        card = Card(recto: "recto", verso: "verso")
    }
    
    func testManagerHas0CardsInitially() {
        XCTAssert(manager.countCards == 0)
    }
    
    func testManagerCanAddACard() {
        manager.add(card: card)
        
        XCTAssert(manager.countCards == 1)
    }
    
    func testManagerRemembersCardsAdded() {
        let secondCard = Card(recto: "2", verso: "2")
        manager.add(card: card)
        manager.add(card: secondCard)
        
        let cards = manager.cards()
        
        XCTAssert(manager.countCards == 2)
        XCTAssert(cards.count == 2)
        XCTAssert(cards.contains(card))
        XCTAssert(cards.contains(secondCard))
    }
    
    func testManagerCannotDrawFromEmptyDeck() {
        XCTAssertThrowsError(try manager.draw()) { (error) in
            XCTAssertEqual(error as? DeckError, DeckError.emptyDeck)
        }
    }
    
    func testCanDrawCard() {
        manager.add(card: card)
        
        XCTAssertNotNil(try manager.draw())
    }
}
