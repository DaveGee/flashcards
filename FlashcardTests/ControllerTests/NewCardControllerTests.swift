import XCTest
@testable import Flashcard

class NewCardTests: XCTestCase {
    
    var viewController: NewCardViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        viewController = storyboard.instantiateViewController(withIdentifier: "NewCardViewController") as! NewCardViewController
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        XCTAssertNotNil(viewController.view)
        viewController.deck = MainUseCase()
    }
    
    func testTitle() {
        viewController.title = "Add a card"
    }
    
    func testHasDeck() {
        XCTAssertNotNil(viewController.deck)
    }
    
    func testCanAddNewCard() {
        let card = Card(recto: "recto", verso: "verso")
        viewController.save(card: card)
        
        XCTAssert(viewController.deck.countCards == 1)
    }
    
    func testCreatesTheCardWithTheRightValues() {
        viewController.recto.text = "recto"
        viewController.verso.text = "verso"
        
        viewController.saveTapped(self)
        XCTAssert(viewController.deck.countCards == 1)
        let card = try! viewController.deck.draw()
        XCTAssert(card.recto == "recto")
        XCTAssert(card.verso == "verso")
    }
}
