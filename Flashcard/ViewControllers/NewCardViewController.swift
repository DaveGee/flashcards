import UIKit

class NewCardViewController: UIViewController {

    @IBOutlet weak var recto: UITextView!
    @IBOutlet weak var verso: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Add a card"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveCard(_ sender: Any) {
        print(recto.text)
        print(verso.text)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
