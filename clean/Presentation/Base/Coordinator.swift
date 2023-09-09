import UIKit

protocol CoordinatorType: AnyObject {
    var navigationController: UINavigationController { get }
    var parentCoordinator: CoordinatorType? { get set }
    
    func start()
    func start(_ coordinator: CoordinatorType)
}

class Coordinator: NSObject, CoordinatorType {
    deinit {
        print("deinit", self.className)
    }
    
    var navigationController: UINavigationController
    var parentCoordinator: CoordinatorType?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        fatalError()
    }
    
    func start(_ coordinator: CoordinatorType) {
        coordinator.parentCoordinator = self
        coordinator.start()
    }
}
