import UIKit

class PlayViewController: UIViewController {
    
    var game = MainUseCase.shared
    private var currentCard: Card? = nil
    
    @IBOutlet weak var cardCounterLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var statsLabel: UILabel!
    @IBOutlet weak var cardFace: UITextView!
    
    var cardsInDeck: Int {
        return game.countCards
    }
    
    var cardsCounter: String {
        return "\(cardsInDeck) card\(plural(cardsInDeck))"
    }
    
    var guess: String {
        if let card = currentCard {
            return card.recto
        } else {
            return "- ? -"
        }
    }
    
    var statsDisplay: String {
        if let card = currentCard {
            let count = card.stat(.draw)
            return "\(count) draw\(plural(count))"
        } else {
            return ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Play"
        
        game.auth {
            if let user = self.game.user {
                self.userLabel.text = user.uid
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        game.loadCards {
            self.cardCounterLabel.text = self.cardsCounter
            self.drawCard()
        }
    }
    
    func drawCard() {
        currentCard = try! game.drawNext()
        if currentCard != nil {
            self.cardFace.text = guess
            self.statsLabel.text = statsDisplay
            self.cardFace.isHidden = false
            self.statsLabel.isHidden = false
        } else {
            self.cardFace.isHidden = true
            self.statsLabel.isHidden = true
        }
    }
    
    func plural(_ count: Int) -> String {
        return count != 1 ? "s" : ""
    }
    
    @IBAction func correctTouched(_ sender: Any) {
    }
    
    @IBAction func wrongTouched(_ sender: Any) {
    }
    
    @IBAction func seeTouched(_ sender: Any) {
    }
}
