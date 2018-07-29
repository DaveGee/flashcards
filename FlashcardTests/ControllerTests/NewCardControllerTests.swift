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
        mockUseCase(user: nil)
    }
    
    func mockUseCase(user: User?) {
        viewController.deck = MainUseCase(user: user)
        viewController.deck.authProxy = AnonymousAuthStub()
        viewController.deck.storeProxy = FirestoreStub()
    }
    
    func testTitle() {
        viewController.title = "Add a card"
    }
    
    func testHasDeck() {
        XCTAssertNotNil(viewController.deck)
    }
    
    func testCanAddNewCard() {
        mockUseCase(user: User(uid: "test"))
        viewController.recto.text = "recto"
        viewController.verso.text = "verso"
        
        viewController.deck.auth {
            try! self.viewController.save()
            XCTAssertEqual(self.viewController.deck.countCards, 1)
        }
        
        
    }
    
    func testThrowsErrorOnSave() {
        viewController.deck.authProxy = FailAuthStub()
        XCTAssertThrowsError(try viewController.save()) { (error) in
            XCTAssertEqual(error as! DeckError, DeckError.invalidUser)
        }   
    }
    
    func testHandlesCreationError() {
        viewController.deck.authProxy = FailAuthStub()
        viewController.saveTapped(self)
        XCTAssertNotNil(viewController.saveError)
    }
}
