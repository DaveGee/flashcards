import XCTest
@testable import Flashcard

class CardTests: XCTestCase {
    
    func testInitCardWith2Langs() {
        _ = Card(recto: "Français", verso: "Francuski", owner: "owner")
    }
    
    func testCantInitFromEmptyDict() {
        let dict: [String: Any?] = [String: Any?]()
        let card = Card(dict)
        
        XCTAssertNil(card)
    }
    
    func testCantInitIfMissingVerso() {
        let dict = ["recto": "x"]
        let card = Card(dict)
        
        XCTAssertNil(card)
    }
    
    func testCantInitIfVersoIsNil() {
        let dict = ["recto": "x", "verso": nil]
        let card = Card(dict)
        XCTAssertNil(card)
    }
    
    func testInitFromDict() {
        let dict: [String: Any] = [
            "recto": "xxx",
            "verso": "yyy",
            "user": "o",
            "created_at": "2018-07-29T13:45:44.112Z",
            "draw_count": 8
        ]
        let card = Card(dict)
        XCTAssertNotNil(card)
        XCTAssertEqual(card?.recto, "xxx")
        XCTAssertEqual(card?.verso, "yyy")
        XCTAssertEqual(card?.owner, "o")
        XCTAssertEqual(card?.stat(.drawn), 8)
    }
    
    func testCardHasDrawCounterTo0() {
        let card = Card(recto: "recto", verso: "verso", owner: "o")
        XCTAssertEqual(card.stat(.drawn), 0)
    }
    
    func testCardTracksDraws() {
        let card = Card(recto: "recto", verso: "verso", owner: "o")
        card.updateStat(.drawn)
        XCTAssertEqual(card.stat(.drawn), 1)
    }
}
