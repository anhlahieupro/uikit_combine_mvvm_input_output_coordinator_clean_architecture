import Foundation
import Combine

final class DetailViewModel: NSObject, ViewModel {
    deinit {
        print("deinit", self.className)
    }
    
    struct Input {
        
    }
    
    struct Output {
        let userData: PassthroughSubject<DetailViewModel.UserData, Never>
    }
    
    enum UserData {
        case success(User)
        case failure(APIError)
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let useCase: DetailViewUseCase
    private let userId: Int
    
    init(useCase: DetailViewUseCase, userId: Int) {
        self.useCase = useCase
        self.userId = userId
    }
    
    func transform(_ input: Input) -> Output {
        let userData = PassthroughSubject<DetailViewModel.UserData, Never>()
        
        useCase.getDetail(userId: userId)
            .sink { completion in
                
                switch completion {
                case .failure(let error):
                    userData.send(.failure(error))
                    
                case .finished:
                    break
                }                
            } receiveValue: { userDetail in
                userData.send(.success(userDetail.data))
            }
            .store(in: &cancellables)
        
        return Output(userData: userData)
    }
}
