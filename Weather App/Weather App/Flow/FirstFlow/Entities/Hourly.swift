import Foundation

struct Hourly: Codable {
    let temperature2M: [Double]
    let windSpeed10M: [Double]
    let relativeHumidity2M: [Double]
    let time: [String]
    
    enum CodingKeys: String, CodingKey {
        case temperature2M = "temperature_2m"
        case windSpeed10M = "windspeed_10m"
        case relativeHumidity2M = "relativehumidity_2m"
        case time
    }
}
