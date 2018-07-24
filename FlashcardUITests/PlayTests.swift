import XCTest

class PlayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testHasNoCards() {
        let app = XCUIApplication()
        XCTAssert(app.staticTexts["cardCounter"].label == "0 cards")
    }
}
