import Firebase
import FirebaseFirestore

class FirestoreDB: FirestoreGateway {
    lazy var db: FirestoreProtocol = Firestore.firestore()
    
    func fetchCards(completion: @escaping ([Card]) -> Void) {
        db.collection("cards").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting cards: \(error)")
            } else {
                let cards: [Card] = querySnapshot!.documents.compactMap {
                    let cardDict = $0.data()
                    return Card($0.documentID, cardDict)
                }
                completion(cards)
            }
        }
    }
    
    func save(card: Card, completion: @escaping () -> Void) {
        if card.id == nil {
            _ = db.collection("cards").addDocument(data: card.data) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                }
                completion()
            }
        } else {

            db.collection("cards").document(card.id!).setData(card.data) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                }
                completion()
            }
        }
    }
}

protocol FirestoreProtocol {
    func collection(_ collectionPath: String) -> CollectionReference
}

extension Firestore: FirestoreProtocol {}
