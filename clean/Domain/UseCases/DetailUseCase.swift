import Foundation
import Combine

protocol DetailViewUseCase {
    var repository: DetailRepository { get }
    
    func getDetail(userId: Int) -> AnyPublisher<UserDetail, APIError>
}

struct ReqresDetailViewUseCase: DetailViewUseCase {
    let repository: DetailRepository
    
    func getDetail(userId: Int) -> AnyPublisher<UserDetail, APIError> {
        repository.getDetail(userId: userId)
    }
}
