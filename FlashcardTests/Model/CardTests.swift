import XCTest
@testable import Flashcard

class CardTests: XCTestCase {
    
    func testInitCardWith2Langs() {
        _ = Card(recto: "Français", verso: "Francuski", owner: "owner")
    }
}
