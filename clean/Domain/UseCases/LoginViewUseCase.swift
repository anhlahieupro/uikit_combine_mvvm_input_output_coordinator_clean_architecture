import Foundation
import Combine

protocol LoginViewUseCase {
    var repository: LoginRepository { get }
    
    func login(email: String, password: String) -> AnyPublisher<LoginData, APIError>
}

struct ReqresLoginViewUseCase: LoginViewUseCase {
    let repository: LoginRepository
    
    func login(email: String, password: String) -> AnyPublisher<LoginData, APIError> {
        repository.request(email: email, password: password)
    }
}
