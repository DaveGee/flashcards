struct User {
    let uid: String
    let isAnonymous: Bool
}

extension User {
    init(uid: String) {
        self.init(uid: uid, isAnonymous: true)
    }
}
