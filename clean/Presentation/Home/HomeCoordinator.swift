import Foundation

final class HomeCoordinator: Coordinator {
    
    override func start() {
        let repository = ReqresHomeRepository()
        let useCase = ReqresHomeViewUseCase(repository: repository)
        let viewModel = HomeViewModel(useCase: useCase)
        let viewController = HomeViewController.loadFromNib()
        viewController.viewModel = viewModel
        viewController.coordinator = self
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToDetail(userId: Int) {
        let coordinator = DetailCoordinator(navigationController: navigationController,
                                            userId: userId)
        start(coordinator)
    }
}
