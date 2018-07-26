import Firebase

class AuthGatewayFirebase: AuthGateway {
    
    lazy var firebaseAuth: AuthProtocol = Auth.auth()
    
    func authAnonymously(completion: @escaping (User?) -> Void) {
        firebaseAuth.signInAnonymously { (authResult, error) in
            if error != nil {
                completion(nil)
                return
            }
            
            if let authResult = authResult {
                let user = User(uid: authResult.user.uid, isAnonymous: authResult.user.isAnonymous)
                
                completion(user)
                return
            }
            
            completion(nil)
        }
    }
}

protocol AuthProtocol {
    func signInAnonymously(completion: AuthDataResultCallback?)
}

extension Auth: AuthProtocol {}
