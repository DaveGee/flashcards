import UIKit

class NewCardViewController: UIViewController {

    @IBOutlet weak var recto: UITextView!
    @IBOutlet weak var verso: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add a card"
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
    }
}
