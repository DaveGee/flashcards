protocol FirestoreGateway {
    func fetchCards(completion: @escaping ([Card]) -> Void)
    func save(card: Card, completion: @escaping () -> Void)
}
