protocol AuthGateway {
    func authAnonymously(completion: @escaping (User?) -> Void)
}
