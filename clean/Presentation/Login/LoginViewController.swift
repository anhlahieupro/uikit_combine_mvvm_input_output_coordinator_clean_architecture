import UIKit
import Combine

final class LoginViewController: BaseViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private var cancellables = Set<AnyCancellable>()
    var viewModel: LoginViewModel!
    var coordinator: LoginCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func setupBinding() {
        let email = CurrentValueSubject<String?, Never>(nil)
        let password = CurrentValueSubject<String?, Never>(nil)
        
        emailTextField.textPublisher()
            .assign(to: \.value, on: email)
            .store(in: &cancellables)
        
        passwordTextField.textPublisher()
            .assign(to: \.value, on: password)
            .store(in: &cancellables)
        
        let login = loginButton.publisher(for: .touchUpInside)
            .eraseToAnyPublisher()
        
        let input = LoginViewModel.Input(email: email,
                                         password: password,
                                         login: login)
        
        let output = viewModel.transform(input)
        
        output.enableLoginButton
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &cancellables)
        
        output.loginState
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] loginState in
                guard let self = self else { return }
                
                switch loginState {
                case .failure(let error):
                    self.alert(title: "ERROR", message: error.localizedDescription)
                    
                case .success:
                    self.passwordTextField.text = ""
                    self.loginButton.isEnabled = false
                    
                    self.coordinator.goToHome()
                }
            })
            .store(in: &cancellables)
    }
    
    override func setupViews() {
        loginButton.layer.cornerRadius = 5
    }
}
