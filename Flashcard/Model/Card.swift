import Foundation

struct Card: Equatable {
    let recto: String
    let verso: String
    let owner: String?
    let createdAt: Date
}

extension Card {
    init(recto: String, verso: String, owner: String?) {
        self.recto = recto
        self.verso = verso
        self.owner = owner
        self.createdAt = Date(timeIntervalSinceNow: 0)
    }
    
    init?(_ dict: [String: Any?]) {
        guard
            let recto = dict["recto"] as? String,
            let verso = dict["verso"] as? String,
            let owner = dict["user"] as? String,
            let createdAt = dict["created_at"] as? String
        else {
            return nil
        }
        
        self.recto = recto
        self.verso = verso
        self.owner = owner
        self.createdAt = Formatter.iso8601.date(from: createdAt) ?? Date(timeIntervalSinceNow: 0)
    }
}
