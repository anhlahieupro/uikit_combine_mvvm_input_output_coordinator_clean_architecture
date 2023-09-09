import UIKit

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: T.className, bundle: nil)
        }
        
        return instantiateFromNib()
    }
}
