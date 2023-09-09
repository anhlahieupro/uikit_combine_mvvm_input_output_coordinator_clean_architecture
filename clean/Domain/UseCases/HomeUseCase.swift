import Foundation
import Combine

protocol HomeViewUseCase {
    var repository: HomeRepository { get }
    
    func getList(page: Int) -> AnyPublisher<Users, APIError>
}

struct ReqresHomeViewUseCase: HomeViewUseCase {
    let repository: HomeRepository
    
    func getList(page: Int) -> AnyPublisher<Users, APIError> {
        repository.getList(page: page)
    }
}
