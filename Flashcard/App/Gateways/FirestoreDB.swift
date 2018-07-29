import Firebase

class FirestoreDB: FirestoreGateway {
    lazy var db: FirestoreProtocol = Firestore.firestore()
    
    func fetchCards(completion: @escaping ([Card]) -> Void) {
        db.collection("cards").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                let cards: [Card] = querySnapshot!.documents.map { document in
                    let cardDict = document.data()
                    return Card(
                        recto: cardDict["recto"] as! String,
                        verso: cardDict["verso"] as! String,
                        owner: cardDict["owner"] as! String?)
                }
                completion(cards)
            }
        }
    }
    
    func save(card: Card, completion: @escaping () -> Void) {
        var ref: DocumentReference? = nil
        ref = db.collection("cards").addDocument(data: [
            "recto": card.recto,
            "verso": card.verso,
            "user": card.owner!,
            "created_at": Formatter.iso8601.string(from: card.createdAt)
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
            completion()
        }

    }
}

protocol FirestoreProtocol {
    func collection(_ collectionPath: String) -> CollectionReference
}

extension Firestore: FirestoreProtocol {}
