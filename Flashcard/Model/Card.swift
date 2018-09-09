import Foundation

class Card {
    private(set) var id: String? = nil

    private(set) var data: [String: Any?] = [:]

    var recto: String {
        return data[Prop.recto] as! String
    }
    var verso: String {
        return data[Prop.verso] as! String
    }
    var owner: String? {
        return data[Prop.user] as! String?
    }
    var createdAt: Date {
        if let date = data[Prop.createdAt] as? String {
            return Formatter.iso8601.date(from: date) ?? Date(timeIntervalSinceNow: 0)
        } else {
            return Date(timeIntervalSinceNow: 0)
        }
    }
    
    private var drawCount: Int {
        get {
            return data[Prop.drawCount] as? Int ?? 0
        }
        set(count) {
            data[Prop.drawCount] = count
        }
    }

    init(recto: String, verso: String, owner: String?) {
        self.data[Prop.recto] = recto
        self.data[Prop.verso] = verso
        self.data[Prop.user] = owner
        self.data[Prop.createdAt] = Formatter.iso8601.string(from: Date(timeIntervalSinceNow: 0))
    }
    
    init?(_ id: String, _ dict: [String: Any?]) {
        guard
            dict[Prop.recto] as? String != nil,
            dict[Prop.verso] as? String != nil,
            dict[Prop.user] as? String != nil,
            dict[Prop.createdAt] as? String != nil
        else {
            return nil
        }

        self.id = id
        self.data = dict
    }

    private enum Prop {
        static let recto = "recto"
        static let verso = "verso"
        static let user = "user"
        static let createdAt = "created_at"
        static let drawCount = "draw_count"
    }
}

extension Card: Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.recto == rhs.recto && lhs.verso == rhs.verso
    }
}

enum CardStat {
    case draw
}

extension Card {
    func stat(_ statType: CardStat) -> Int {
        switch statType {
        case .draw: return self.drawCount
        }
    }
    
    func updateStat(_ statType: CardStat) {
        switch statType {
        case .draw: self.drawCount = self.drawCount + 1
        }
    }
}
