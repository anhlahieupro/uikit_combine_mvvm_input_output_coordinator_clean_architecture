import UIKit

class BaseViewController: UIViewController {
    
    deinit {
        print("deinit", self.className)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupViews()
    }
    
    func setupBinding() { }
    
    func setupViews() { }
    
    func alert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
}
