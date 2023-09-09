import UIKit

final class DetailCoordinator: Coordinator {
    private let userId: Int
    
    init(navigationController: UINavigationController, userId: Int) {
        self.userId = userId
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        let repository = ReqresDetailRepository()
        let useCase = ReqresDetailViewUseCase(repository: repository)
        let viewModel = DetailViewModel(useCase: useCase, userId: userId)
        let viewController = DetailViewController.loadFromNib()
        viewController.viewModel = viewModel
        viewController.coordinator = self
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(viewController, animated: true)
    }
}
