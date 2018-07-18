import XCTest
@testable import Flashcard

class CardRepositoryTests: XCTestCase {
    
    var repository: CardRepository!
    var card: Card!
    
    override func setUp() {
        repository = CardRepository()
        card = Card(recto: "recto", verso: "verso")
    }
    
    func testRepositoryHasNoCardInitially() {
        XCTAssert(repository.countCards == 0)
    }
    
    func testRepositoryCanAddACard() {
        repository.add(card: card)
        
        XCTAssert(repository.countCards == 1)
    }
    
    func testRepositoryCanRetrieveLastCardAdded() {
        repository.add(card: card)
        
        let newCard = repository.card(atIndex: 0)
        
        XCTAssert(newCard == card)
    }
    
    func testRepositoryCanHave2Cards() {
        let secondCard = Card(recto: "2", verso: "2")
        repository.add(card: card)
        repository.add(card: secondCard)
        
        let storedCard = repository.card(atIndex: 1)
        
        XCTAssert(storedCard == secondCard)
        XCTAssert(repository.countCards == 2)
    }
}
