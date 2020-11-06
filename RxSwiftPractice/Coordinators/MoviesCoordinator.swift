import UIKit
import RxSwift
import SafariServices

class MoviesCoordinator: BaseCoordinator {
    
    private let window: UIWindow
    private let disposeBag = DisposeBag()
    private let viewModel = MoviesViewModel()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let viewController = MoviesViewController()
        viewController.viewModel = viewModel
        
        navigationController.setViewControllers([viewController], animated: true)
        
        viewModel.selectMovie.subscribe(onNext: { [weak self] in
            self?.showMovie(with: $0) })
            .disposed(by: disposeBag)
        
        setupBindings()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func showMovie(with movieViewModel: MovieViewModel) {
        let movieCoordinator = MovieCoordinator(viewModel: movieViewModel)
        movieCoordinator.parentViewModel = self.viewModel
        movieCoordinator.navigationController = self.navigationController
        coordinate(to: movieCoordinator)
    }
        
    // MARK: - Helper methods
    private func setupBindings() {
        viewModel.childDismissed.bind(onNext: { [weak self] in
            self?.removeChildCoordinators()
        }).disposed(by: disposeBag)
    }
    
}
