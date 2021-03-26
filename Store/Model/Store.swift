import Foundation
import Firebase

class Store {
    
    var store : [StoredProduct]
    
    func getStore() -> [StoredProduct] {
        return store
    }
    
    class func getValue(_ completion: @escaping (Store) -> Swift.Void) {
        
        let ref = Database.database().reference(withPath: "products")
        
        ref.observe(.value, with: {  (snapshot) in
            
            if snapshot.exists() {
                var _products = Array<StoredProduct>()
                
                for item in snapshot.children {
                    
                    let product = StoredProduct(snapshot: item as! DataSnapshot)
                    _products.append(product)
                }
                let store = Store.init(store: _products)
                completion(store)
            }
        })
    }
    
    class func updateQuantity(product: StoredProduct) {
                    
            let childRef = product.ref?.child(product.uid)
            var quantity = product.quantity
            quantity -= 1
            let values = ["quantity": quantity] as [String : Any]
            childRef?.updateChildValues(values)
            product.ref?.updateChildValues(values)
    }
    
    class func updateValue(ref: DatabaseReference, model: String, price: Int, quantity: Int, childKey: String) {
        
        let ref = Database.database().reference(withPath: "products")
        
        if childKey != "" {
            
            let childRef = ref.child(childKey)
            
            let values = ["model": model, "price": price,"quantity": quantity, "uid": childKey] as [String : Any]
            
            childRef.updateChildValues(values)
            print("saveNewItemPresed")
        }
        if childKey == "" {
            let childRef = ref.childByAutoId()
            
            let values = ["model": model, "price": price,"quantity": quantity, "uid": childRef.key as Any] as [String : Any]
            
            childRef.updateChildValues(values)
            print("saveItemPresed")
        }
    }
    
    class func removeValue(childKey: String) {
        let ref = Database.database().reference(withPath: "products")
        ref.child(childKey).removeValue()
    }
    
    init() {
        store = [StoredProduct]()
    }
    init(store: [StoredProduct]) {
        self.store = store
    }
    
}

