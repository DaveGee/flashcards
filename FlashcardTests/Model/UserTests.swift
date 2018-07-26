import XCTest
@testable import Flashcard

class UserTests: XCTestCase {
    
    func testUserHasId() {
        _ = User(uid: "myid")
    }
    
    func testUserCanBeAnonymous() {
        let user1 = User(uid: "myid", isAnonymous: true)
        let user2 = User(uid: "myid")
        
        XCTAssertTrue(user1.isAnonymous)
        XCTAssertTrue(user2.isAnonymous)
    }
}
