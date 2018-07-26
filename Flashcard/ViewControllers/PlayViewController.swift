import UIKit

class PlayViewController: UIViewController {
    
    var game = MainUseCase.shared
    
    @IBOutlet weak var cardCounterLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
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
        cardCounterLabel.text = cardsCounter
    }
}
