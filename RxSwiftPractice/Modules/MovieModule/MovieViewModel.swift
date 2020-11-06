import RxSwift

final class MovieViewModel {
    
    let dismissed = PublishSubject<Void>()
    
    private var movie: Movie

    init(movie: Movie) {
        self.movie = movie
    }

    var overview: String {
        return movie.overview
    }

    var posterImageLink: String {
        return "https://image.tmdb.org/t/p/w500" + movie.posterImageLink
    }

    func getImageData(completion: @escaping(Data) -> Void) {
        guard let url = URL(string: posterImageLink) else { return }
        ImageDataService.shared.getImageDataHolder(withURL: url) { (dataHolder) in
            guard let dataHolder = dataHolder else { return }
            completion(dataHolder.data)
        }
    }

}
