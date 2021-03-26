import UIKit
import FirebaseDatabase


class ListOfProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref : DatabaseReference!
    var storedProducts = [StoredProduct]()
    var childKeyArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "products")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        ref.observe(.value) { [weak self] (snapshot) in
            
            var _storedProducts = [StoredProduct]()
            var _childKeyArray = [String]()
            
            for item in snapshot.children {
                let product = StoredProduct(snapshot: item as! DataSnapshot)
                _storedProducts.append(product)
                _childKeyArray.append((item as! DataSnapshot).key)
            }
            
            self?.storedProducts = _storedProducts
            self?.childKeyArray = _childKeyArray
            self?.tableView.reloadData()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        ref.removeAllObservers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "addOrChangeSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! AddProductViewController
                destinationVC.model = self.storedProducts[indexPath.row].model
                destinationVC.price = self.storedProducts[indexPath.row].price
                destinationVC.quantity = self.storedProducts[indexPath.row].quantity
                destinationVC.childKey = self.childKeyArray[indexPath.row]
                print(childKeyArray[indexPath.row])

            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedProducts.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let childKey = childKeyArray[indexPath.row]
            ref.child(childKey).removeValue()
            Store.removeValue(childKey: childKey)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CellOfProduct
        let storedProduct = storedProducts[indexPath.row]
        
        cell.modelLabel.text = storedProduct.model
        cell.quantityLabel.text = String(storedProduct.quantity)
        
        return cell
    }
}
