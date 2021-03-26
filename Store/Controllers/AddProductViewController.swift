import UIKit
import FirebaseDatabase

class AddProductViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var errorName: UILabel!
    @IBOutlet weak var errorPrice: UILabel!
    @IBOutlet weak var errorQuantity: UILabel!
    
    var model: String!
    var price: Int!
    var quantity: Int!
    var convertingSuccess = false
    var childKey = ""
    
    var keyboardH =  CGFloat()
    var ref: DatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        modelTextField.text = model
        
        if price != nil {
            priceTextField.text = String(price)
        }
        if quantity != nil {
            quantityTextField.text = String(quantity)
        }
    

        
        ref = Database.database().reference(withPath: "products")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        


        
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            keyboardH = keyboardHeight
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        modelTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
        quantityTextField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let mainViewHight = self.view.bounds.size.height
        let mainViewWidth = self.view.bounds.size.width

        if textField == priceTextField {
            UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .calculationModeLinear, animations: {
                if UIScreen.main.bounds.height > 568 {
                    self.view.center = CGPoint(x: mainViewWidth / 2, y: mainViewHight / 2 - 57)
                }
            }, completion: nil)
        }
        if textField == quantityTextField {
            UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .calculationModeLinear, animations: {
                if UIScreen.main.bounds.height > 568 {
                    self.view.center = CGPoint(x: mainViewWidth / 2, y: mainViewHight / 2 - 258)
                }
            }, completion: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let mainViewHight = self.view.bounds.size.height
        let mainViewWidth = self.view.bounds.size.width
        
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .calculationModeLinear, animations: {
            if UIScreen.main.bounds.height > 568 {
                self.view.center = CGPoint(x: mainViewWidth / 2, y: mainViewHight / 2)
            }
        }, completion: nil)
    }

    @IBAction func saveItem(_ sender: UIBarButtonItem) {

        
        if (modelTextField.text?.isEmpty)! || (priceTextField.text?.isEmpty)! || (quantityTextField.text?.isEmpty)! {
            errorAlert(description: "Все поля должны быть заполнены")
            return
        }
        
            getPriceAndQuantity()
        
            if convertingSuccess == true {
                Store.updateValue(ref: ref, model: model, price: price, quantity: quantity, childKey: childKey)
                _ = navigationController?.popViewController(animated: true)
        }
        
    }
    
    func getPriceAndQuantity() {
        
        let price: Int? = Int(priceTextField.text!)
        let quantity: Int? = Int(quantityTextField.text!)
        if price == nil  {
                errorAlert(description: "Введите в поле \"Цена\" числовое значение")
        }
        if quantity == nil {
                errorAlert(description: "Введите в поле \"Количество\" числовое значение")
        }
        if price != nil && quantity != nil && modelTextField.text != nil {
            self.price = price!
            self.quantity = quantity!
            model = modelTextField.text!
            convertingSuccess = true
        }
        
    }
    
    func errorAlert(description: String) {
        let ac = UIAlertController(title: "Ошибка", message: description, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(okAction)
        
        self.present(ac, animated: true, completion: nil)
    }
}
