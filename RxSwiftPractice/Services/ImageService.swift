import Foundation

class DataHolder {
    let data: Data
    init(data: Data) {
        self.data = data
    }
}

class ImageDataService {
    
    static let shared = ImageDataService()
    private let cache = NSCache<NSString, DataHolder>()
    
    private init() {}
    
    private func downloadImageData(withURL url: URL, completion: @escaping (_ data: DataHolder?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, resposeURL, error in
            var downloadedData: DataHolder?
            
            if let data = data {
                downloadedData = DataHolder(data: data)
            }
            
            if let downloadedData = downloadedData {
                self.cache.setObject(downloadedData, forKey: url.absoluteString as NSString)
            }
            
            completion(downloadedData)
        }
        
        task.resume()
    }
    
    func getImageDataHolder(withURL url: URL, completion: @escaping (_ data: DataHolder?) -> Void) {
        if let dataHolder = cache.object(forKey: url.absoluteString as NSString) {
            completion(dataHolder)
        } else {
            downloadImageData(withURL: url, completion: completion)
        }
    }
    
}
