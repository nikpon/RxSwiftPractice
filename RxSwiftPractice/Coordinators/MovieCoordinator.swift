import RxSwift

class MovieCoordinator: BaseCoordinator {
    
    private var viewModel: MovieViewModel!
    weak var parentViewModel: MoviesViewModel!
    private let disposeBag = DisposeBag()
    
    init(viewModel: MovieViewModel) {
        self.viewModel = viewModel
    }
    
    override func start() {
        let viewController = MovieViewController()
        viewController.viewModel = self.viewModel
                
        viewModel.dismissed.bind(to: parentViewModel.childDismissed)
            .disposed(by: disposeBag)
        
        viewController.modalPresentationStyle = .fullScreen
//        navigationController.presentOnTop(viewController, animated: true)
        navigationController.pushViewController(viewController, animated: true)
    }
    

    
}
