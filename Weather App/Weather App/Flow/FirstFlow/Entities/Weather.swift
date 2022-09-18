import Foundation

struct Weather: Codable {
    let latitude, longitude: Double
    let hourly: Hourly
}
