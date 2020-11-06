import RxSwift
import RxCocoa

final class MoviesViewModel {
    
    private let networkService: NetworkServiceProtocol
    private let disposeBag = DisposeBag()
    
    let selectMovie = PublishSubject<MovieViewModel>()
    var childDismissed = PublishSubject<Void>()
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchMovies(searchTerm: String? = nil) -> Observable<[MovieViewModel]> {
        let path = searchTerm != nil ? "/3/search/movie" : "/3/trending/all/day"
        
        let queryItems: [URLQueryItem]?
        if let searchTerm = searchTerm {
            queryItems = [URLQueryItem(name: "query", value: searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))] // searchTerm with allowed spaces between the words
        } else {
            queryItems = nil
        }
        
        return networkService.fetchMovies(for: path, extraQueryItems: queryItems).map {
            $0.items.map {
                MovieViewModel(movie: $0)
            }
        }
    }
    
}
