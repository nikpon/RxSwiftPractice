import Foundation

struct Movie: Decodable {
    let name: String?
    let overview: String
    let posterImageLink: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case overview
        case posterImageLink = "poster_path"
    }
}

struct Movies: Decodable {
    let items: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case items = "results"
    }
}
