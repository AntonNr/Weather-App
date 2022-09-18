import Foundation

struct City: Codable {
    var name: String?
    let latitude, longitude: Double
}

struct ResultOfRequest: Codable {
    var results: [City]?
}
