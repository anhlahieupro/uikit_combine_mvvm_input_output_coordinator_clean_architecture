import Foundation
import Combine

final class HomeViewModel: NSObject, ViewModel {
    deinit {
        print("deinit", self.className)
    }
    
    struct Input {
        let loadMore: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let users: CurrentValueSubject<[User], Never>
    }
    
    private var relays = Relays()
    private struct Relays {
        var isEnd = false
        var isLoading = false
        var page = 1
        let users = CurrentValueSubject<[User], Never>([])
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let useCase: HomeViewUseCase
    
    init(useCase: HomeViewUseCase) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        input.loadMore
            .sink { [weak self] _ in
                guard let self = self, !self.relays.isLoading, !self.relays.isEnd else { return }
                
                self.relays.isLoading = true
                self.useCase.getList(page: self.relays.page)
                    .sink { [weak self] completion in
                        guard let self = self else { return }
                        
                        switch completion {
                        case .failure:
                            break
                            
                        case .finished:
                            self.relays.page += 1
                            self.relays.isLoading = false
                        }                        
                    } receiveValue: { [weak self] value in
                        guard let self = self else { return }
                        var users = self.relays.users.value
                        let newUsers = value.data
                        users.append(contentsOf: newUsers)
                        
                        self.relays.users.send(users)
                        self.relays.isEnd = newUsers.isEmpty
                    }
                    .store(in: &cancellables)
            }
            .store(in: &cancellables)
        
        return Output(users: relays.users)
    }
}
