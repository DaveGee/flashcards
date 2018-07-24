import XCTest

class AddCardTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testAddsCardWithRectoAndVerso() {
        
        let app = XCUIApplication()
        app.navigationBars["Play"].buttons["Add a card"].tap()
        
        app.textViews["rectoTextView"].tap()
        app.textViews["rectoTextView"].typeText("Test recto")
        app.textViews["versoTextView"].tap()
        app.textViews["versoTextView"].typeText("Test verso")
        
        app/*@START_MENU_TOKEN@*/.buttons["saveCardButton"]/*[[".buttons[\"save\"]",".buttons[\"saveCardButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        print(app.staticTexts["cardCounter"].label)
        XCTAssert(app.staticTexts["cardCounter"].label == "1 card")
    }
}
