import RxSwift
import RxCocoa

final class MoviesViewController: UIViewController {
    
    // MARK: - Properties
    private let tableView = UITableView()
    private var searchController = UISearchController(searchResultsController: nil)
    
    var viewModel: MoviesViewModel!
    private let disposeBag = DisposeBag()
     
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureUI()
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureTableView()
        configureSearchController()
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = 250
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = 250
        tableView.register(MoviesCell.self, forCellReuseIdentifier: MoviesCell.reuseIdentifier)
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    private func configureSearchController() {
        searchController.searchBar.placeholder = "Search for movie"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.sizeToFit()
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func configureNavigationBar() {
        title = "Movies"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: - Bind UI
    private func bindViewModel() {
        let results = searchController.searchBar.rx.text.orEmpty
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { [unowned self] query -> Observable<[MovieViewModel]> in
                if query.isEmpty {
                    return self.viewModel.fetchMovies()
                }
                return self.viewModel.fetchMovies(searchTerm: query).catchErrorJustReturn([])
        }.observeOn(MainScheduler.instance)
        
        DispatchQueue.main.async { // To silence "UITableView was told to layout.." warning, seems like iOS 13.1 bug
            results.bind(to: self.tableView.rx.items(cellIdentifier: MoviesCell.reuseIdentifier, cellType: MoviesCell.self)) { index, viewModel, cell in
                cell.configure(with: viewModel)
            }
            .disposed(by: self.disposeBag)
        }
        
        tableView.rx.modelSelected(MovieViewModel.self)
            .bind(to: viewModel.selectMovie)
            .disposed(by: disposeBag)
    }
    
}
