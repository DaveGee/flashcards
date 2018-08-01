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
        viewController.game = MainUseCase()
        viewController.game.storeProxy = FirestoreStub()
        viewController.game.authProxy = AnonymousAuthStub()
    }
    
    func testTitle() {
        viewController.title = "Play"
    }
    
    func testHas0CardsInitially() {
        XCTAssertEqual(viewController.cardsInDeck, 0)
    }
    
    func testCanCountCardsInDeck() {
        addCardToDeck()
        XCTAssertEqual(viewController.cardsInDeck, 1)
    }
    
    func testCanDisplayNumberOfCards() {
        XCTAssertEqual(viewController.cardsCounter, "0 cards")
        
        addCardToDeck()
        XCTAssertEqual(viewController.cardsCounter, "1 card")
        
        addCardToDeck()
        XCTAssertEqual(viewController.cardsCounter, "2 cards")
    }
    
    func testCanDrawCard() {
        addCardToDeck()
        addCardToDeck()
        
        viewController.viewDidLoad()
        
        viewController.drawCard()
        XCTAssertEqual(viewController.guess, "recto")
        XCTAssertEqual(viewController.statsDisplay, "1 draw")
    }
    
    func addCardToDeck() {
        var cards = viewController.game.cards()
        cards.append(Card(recto: "recto", verso: "verso", owner: "0"))
        let store = FirestoreStub(cards: cards)
        viewController.game.storeProxy = store
        viewController.game.loadCards {}
    }
}
