import Firebase

class FirestoreDB: FirestoreGateway {
    lazy var db: FirestoreProtocol = Firestore.firestore()
    
    func fetchCards(completion: @escaping ([Card]) -> Void) {
        db.collection("cards").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                let cards: [Card] = querySnapshot!.documents.compactMap {
                    let cardDict = $0.data()
                    return Card(cardDict)
                }
                completion(cards)
            }
        }
    }
    
    func save(card: Card, completion: @escaping () -> Void) {
        _ = db.collection("cards").addDocument(data: [
            "recto": card.recto,
            "verso": card.verso,
            "user": card.owner!,
            "created_at": Formatter.iso8601.string(from: card.createdAt)
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }
            completion()
        }

    }
}

protocol FirestoreProtocol {
    func collection(_ collectionPath: String) -> CollectionReference
}

extension Firestore: FirestoreProtocol {}
