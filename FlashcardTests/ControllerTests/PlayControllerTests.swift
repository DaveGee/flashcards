import XCTest
@testable import Flashcard

class PlayControllerTests: XCTestCase {
    
    var viewController: PlayViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        viewController = storyboard.instantiateViewController(withIdentifier: "PlayViewController") as! PlayViewController
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        XCTAssertNotNil(viewController.view)
        viewController.deck = DeckManager()
    }
    
    func testTitle() {
        viewController.title = "Play"
    }
    
    func testHas0CardsInitially() {
        XCTAssert(viewController.cardsInDeck == 0)
    }
    
    func testCanCountCardsInDeck() {
        addCardToDeck()
        XCTAssert(viewController.cardsInDeck == 1)
    }
    
    func testCanDisplayNumberOfCards() {
        XCTAssert(viewController.cardsCounter == "0 cards")
        
        addCardToDeck()
        XCTAssert(viewController.cardsCounter == "1 card")
        
        addCardToDeck()
        XCTAssert(viewController.cardsCounter == "2 cards")
    }
    
    func addCardToDeck() {
        viewController.deck.add(card: Card(recto: "recto", verso: "verso"))
    }
}
