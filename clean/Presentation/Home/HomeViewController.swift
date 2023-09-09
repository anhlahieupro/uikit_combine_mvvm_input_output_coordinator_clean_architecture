import UIKit
import Combine

final class HomeViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var cancellables = Set<AnyCancellable>()
    var viewModel: HomeViewModel!
    var coordinator: HomeCoordinator!
    
    private let relays = Relays()
    private struct Relays {
        let loadMore = PassthroughSubject<Void, Never>()
        let users = CurrentValueSubject<[User], Never>([])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupBinding() {
        relays.users
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)
        
        let input = HomeViewModel.Input(loadMore: relays.loadMore)
        let output = viewModel.transform(input)
        
        output.users
            .assign(to: \.value, on: relays.users)
            .store(in: &cancellables)
        
        relays.loadMore.send(())
    }
    
    override func setupViews() {
        navigationItem.title = "HOME"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(logout))
    }
    
    @objc private func logout() {
        navigationController?.popViewController(animated: true)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relays.users.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
        
        if indexPath.row < relays.users.value.count {
            let user = relays.users.value[indexPath.row]
            cell.textLabel?.text = user.email
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if relays.users.value.count > 4
            && indexPath.row >= relays.users.value.count - 4 {
            
            relays.loadMore.send(())
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user = relays.users.value[indexPath.row]
        coordinator.goToDetail(userId: user.id)
    }
}
