import UIKit

class PlayViewController: UIViewController {
    
    var deck = DeckManager.shared
    
    @IBOutlet weak var cardCounterLabel: UILabel!
    
    var cardsInDeck: Int {
        return deck.countCards
    }
    
    var cardsCounter: String {
        return "\(cardsInDeck) card\(cardsInDeck != 1 ? "s" : "")"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Play"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cardCounterLabel.text = cardsCounter
    }
}
