import UIKit

class NewCardViewController: UIViewController {
    
    var deck = DeckManager.shared

    @IBOutlet weak var recto: UITextView!
    @IBOutlet weak var verso: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add a card"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recto.becomeFirstResponder()
    }
    
    func save(card: Card) {
        deck.add(card: card)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        save(card: Card(recto: recto.text, verso: verso.text))
        _ = navigationController?.popToRootViewController(animated: true)
    }
}
