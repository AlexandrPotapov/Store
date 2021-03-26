import Foundation
import Firebase
import FirebaseDatabase

struct StoredProduct {
    
    let uid: String
    let model: String
    let price: Int
    let quantity: Int
    let ref: DatabaseReference?
    
    init(model: String, price: Int, quantity: Int, uid: String) {
        self.model = model
        self.price = price
        self.quantity = quantity
        self.uid = uid
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        model = snapshotValue["model"] as! String
        price = snapshotValue["price"] as! Int
        quantity = snapshotValue["quantity"] as! Int
        uid = snapshotValue["uid"] as! String
        ref = snapshot.ref
    }
}
