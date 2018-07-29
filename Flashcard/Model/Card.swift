import Foundation

struct Card: Equatable {
    let recto: String
    let verso: String
    let owner: String?
    let createdAt = Date(timeIntervalSinceNow: 0)
}
