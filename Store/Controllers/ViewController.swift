import UIKit
import Firebase

class ViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
    
    var ref: DatabaseReference!
    var products = Store()
    var slides:[Slide] = []
    
    func fetchData() {
        Store.getValue({ [weak self] (store) in
            self?.products = store
            self?.slides = (self?.createSlides(products: (self?.products)!))!
            self?.setupSlideScrollView(slides: (self?.slides)!)
            self?.activityIndicator.stopAnimating()

        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        ref = Database.database().reference(withPath: "products")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createSlides(products: Store) -> [Slide] {
        var slides = [Slide]()

        
        for product in products.getStore() {
            let slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide

            slide.modelLabel.text = product.model
            slide.priceLabel.text = String(product.price)
            slide.quantityLabel.text = String(product.quantity)
            slide.onClickCallback = {
                
                Store.updateQuantity(product: product)
                
                let childRef = self.ref.child(product.uid)
                var quantity = product.quantity
                quantity -= 1
                let values = ["quantity": quantity] as [String : Any]
                childRef.updateChildValues(values)
            }
            if product.quantity > 0 {
            slides.append(slide)
            }
        }
        
        return slides
    }
    
    func setupSlideScrollView(slides : [Slide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
}

