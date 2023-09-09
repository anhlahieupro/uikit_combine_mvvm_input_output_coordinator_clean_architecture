import Foundation
import Combine

protocol DetailRepository {
    func getDetail(userId: Int) -> AnyPublisher<UserDetail, APIError>
}

struct ReqresDetailRepository: DetailRepository {
    func getDetail(userId: Int) -> AnyPublisher<UserDetail, APIError> {
        let url = URL(string: ReqresAPI.users + "/" + String(userId))!
        let method = API.Method.get
        let api = API(url: url, method: method, parameters: nil)
        return api.request()
    }
}
