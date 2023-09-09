import Foundation
import Combine

protocol HomeRepository {
    func getList(page: Int) -> AnyPublisher<Users, APIError>
}

struct ReqresHomeRepository: HomeRepository {
    func getList(page: Int) -> AnyPublisher<Users, APIError> {
        let url = URL(string: ReqresAPI.users)!
        let method = API.Method.get
        let parameters = ["page": page]
        let api = API(url: url, method: method, parameters: parameters)
        return api.request()
    }
}
