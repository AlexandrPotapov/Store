import UIKit

class Slide: UIView {
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    var onClickCallback: (() -> Void)?


    @IBAction func buyButtonPressed(_ sender: Any) {
        onClickCallback!()
    }
    
}
