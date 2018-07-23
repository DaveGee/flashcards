import XCTest
@testable import Flashcard

class NewCardTests: XCTestCase {
    
    var viewController: NewCardViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        viewController = storyboard.instantiateViewController(withIdentifier: "NewCardViewController") as! NewCardViewController
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        XCTAssertNotNil(viewController.view);
    }
    
    func test() {
        XCTAssertTrue(true)
    }
}