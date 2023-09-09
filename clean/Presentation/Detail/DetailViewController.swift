import UIKit
import Combine

class DetailViewController: BaseViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    private var cancellables = Set<AnyCancellable>()
    var viewModel: DetailViewModel!
    var coordinator: DetailCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupBinding() {
        let input = DetailViewModel.Input()
        let output = viewModel.transform(input)
        
        output.userData
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] userData in
                guard let self = self else { return }
                
                switch userData {
                case .failure(let error):
                    self.alert(title: "ERROR", message: error.localizedDescription)
                    
                case .success(let user):
                    self.imageView.load(url: URL(string: user.avatar)!)
                    self.label.text = user.description
                }                
            })
            .store(in: &cancellables)
    }
    
    override func setupViews() {
        navigationItem.title = "DETAIL"
        imageView.layer.cornerRadius = imageView.bounds.width / 2
    }
}
