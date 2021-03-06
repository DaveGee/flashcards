import UIKit

class NewCardViewController: UIViewController, UITextViewDelegate {
    
    var deck = MainUseCase.shared
    
    var saveError: Error? = nil

    @IBOutlet weak var recto: UITextView!
    @IBOutlet weak var verso: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add a card"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func save() throws {
        try deck.createCard(recto: recto.text, verso: verso.text) {}
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentInset.bottom)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        do {
            saveError = nil
            try save()
            _ = navigationController?.popToRootViewController(animated: true)
        } catch {
            saveError = error
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}
