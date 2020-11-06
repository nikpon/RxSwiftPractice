import RxSwift

protocol NetworkServiceProtocol {
    func fetchMovies(for path: String, extraQueryItems: [URLQueryItem]?) -> Observable<Movies>
}

class NetworkService: NetworkServiceProtocol {
    
    public func fetchMovies(for path: String, extraQueryItems: [URLQueryItem]?) -> Observable<Movies> {
        return request(for: path, extraQueryItems: extraQueryItems)
    }
    
    private func request<T: Decodable>(for path: String, extraQueryItems: [URLQueryItem]?) -> Observable<T> {
        var fullQueryItems = [URLQueryItem(name: "api_key", value: ApiKey.key)]
        
        if let extraQueryItems = extraQueryItems {
            fullQueryItems += extraQueryItems
        }
        
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.themoviedb.org"
        component.path = path
        component.queryItems = fullQueryItems
        
        guard let url = component.url else { fatalError("Couldn't build url") }
        
        return Observable.create { (observer) -> Disposable in
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    if let error = error {
                        observer.onError(NetworkError.serverError(error: error))
                        return
                    }
                    observer.onError(NetworkError.noConnectionError)
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(decoded)
                } catch {
                    observer.onError(NetworkError.incorrectDataError)
                }
                observer.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
}
