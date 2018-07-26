import XCTest
import Firebase
@testable import Flashcard

class AuthGatewayFirebaseTests: XCTestCase {
    
    var sut: AuthGatewayFirebase!
    var mock: MockFirebaseAuth!
    
    override func setUp() {
        super.setUp()
        sut = AuthGatewayFirebase()
        mock = MockFirebaseAuth()
        sut.firebaseAuth = mock
    }
    
    func testLoginsAnonymously() {
        let completion = { (user: Flashcard.User?) in }
        
        sut.authAnonymously(completion: completion)
        XCTAssertTrue(mock.signInAnonymouslyCalled)
    }
    
}

class MockFirebaseAuth: AuthProtocol {
    var signInAnonymouslyCalled = false
    
    func signInAnonymously(completion: AuthDataResultCallback?) {
        self.signInAnonymouslyCalled = true
    }
}
