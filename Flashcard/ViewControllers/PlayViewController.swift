import UIKit

class PlayViewController: UIViewController {
    
    var game = MainUseCase.shared
    
    @IBOutlet weak var cardCounterLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var statsLabel: UILabel!
    @IBOutlet weak var cardFace: UITextView!
    
    var cardsInDeck: Int {
        return game.countCards
    }
    
    var cardsCounter: String {
        return "\(cardsInDeck) card\(cardsInDeck != 1 ? "s" : "")"
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
        }
    }
    @IBAction func correctTouched(_ sender: Any) {
    }
    @IBAction func wrongTouched(_ sender: Any) {
    }
    @IBAction func seeTouched(_ sender: Any) {
    }
}
