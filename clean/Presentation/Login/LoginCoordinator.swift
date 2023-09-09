import Foundation

final class LoginCoordinator: Coordinator {
    
    override func start() {
        let repository = ReqresLoginRepository()
        let useCase = ReqresLoginViewUseCase(repository: repository)
        let viewModel = LoginViewModel(useCase: useCase)
        let viewController = LoginViewController.loadFromNib()
        viewController.viewModel = viewModel
        viewController.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToHome() {
        let coordinator = HomeCoordinator(navigationController: navigationController)
        start(coordinator)
    }
}
