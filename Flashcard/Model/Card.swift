import Foundation

class Card {
    let recto: String
    let verso: String
    let owner: String?
    let createdAt: Date
    
    private var drawCount = 0

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
        
        self.drawCount = dict["draw_count"] as? Int ?? 0
    }
}

extension Card: Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.recto == rhs.recto && lhs.verso == rhs.verso
    }
}

enum CardStat {
    case drawn
}

extension Card {
    func stat(_ statType: CardStat) -> Int {
        switch statType {
        case .drawn: return self.drawCount
        }
    }
    
    func updateStat(_ statType: CardStat) {
        switch statType {
        case .drawn: self.drawCount = self.drawCount + 1
        }
    }
}
