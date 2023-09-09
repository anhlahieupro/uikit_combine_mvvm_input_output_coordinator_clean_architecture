import UIKit
import Combine

class LoginViewModel: NSObject, ViewModel {
    deinit {
        print("deinit", self.className)
    }
    
    struct Input {
        let email: CurrentValueSubject<String?, Never>
        let password: CurrentValueSubject<String?, Never>
        let login: AnyPublisher<UIControl, Never>
    }
    
    struct Output {
        let enableLoginButton: CurrentValueSubject<Bool, Never>
        let loginState: PassthroughSubject<LoginState, Never>
    }
    
    enum LoginState {
        case success(LoginData)
        case failure(APIError)
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let useCase: LoginViewUseCase
    
    init(useCase: LoginViewUseCase) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let enableLoginButton = CurrentValueSubject<Bool, Never>(false)
        
        Publishers.CombineLatest(input.email, input.password)
            .map { email, password in
                guard let email = email, let password = password else { return false }
                return !email.isEmpty && !password.isEmpty
            }
            .sink { value in
                enableLoginButton.send(value)
            }
            .store(in: &cancellables)
        
        let loginState = PassthroughSubject<LoginState, Never>()
        input.login
            .sink { [weak self] _ in
                
                guard let self = self,
                      let email = input.email.value,
                      let password = input.password.value else { return }
                
                self.useCase.login(email: email, password: password)
                    .sink { completion in
                        
                        switch completion {
                        case .failure(let error):
                            loginState.send(.failure(error))
                            
                        case .finished:
                            break
                        }
                        
                    } receiveValue: { loginData in
                        loginState.send(.success(loginData))
                    }
                    .store(in: &self.cancellables)                
            }
            .store(in: &cancellables)
        
        return Output(enableLoginButton: enableLoginButton,
                      loginState: loginState)
    }
}
