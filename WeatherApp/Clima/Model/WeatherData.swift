import Foundation

struct WeatherData: Codable {
    var name: String
    var main: Main
    var weather: [Weather]
    var sys: Sys
}

struct Main: Codable {
    var temp: Double
}

struct Weather: Codable {
    var id: Int
    var description: String
}

struct Sys: Codable {
    var country: String
}
