import Foundation
import Combine

protocol LoginRepository {
    func request(email: String, password: String) -> AnyPublisher<LoginData, APIError>
}

struct ReqresLoginRepository: LoginRepository {
    func request(email: String, password: String) -> AnyPublisher<LoginData, APIError> {
        let url = URL(string: ReqresAPI.login)!
        let method = API.Method.post
        let parameters = ["email": email, "password": password]
        let api = API(url: url, method: method, parameters: parameters)
        return api.request()
    }
}
