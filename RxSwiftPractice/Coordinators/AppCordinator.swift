import RxSwift

class AppCoordinator: BaseCoordinator {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let moviesCoordinator = MoviesCoordinator(window: window)
        return coordinate(to: moviesCoordinator)
    }
    
}
