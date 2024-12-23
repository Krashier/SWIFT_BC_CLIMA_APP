import Foundation

struct WeatherModel {
    var cityId: Int
    var cityTemperature: Double
    var cityName: String
    var country: String
    
    var cityTemperatureString: String {
        return String(format: "%.1f", cityTemperature)
    }
    
    var conditionName: String {
        switch cityId {
        case 200...233:
            return "cloud.bolt.rain.fill"
        case 300...322:
            return "cloud.drizzle.fill"
        case 500...532:
            return "cloud.rain.fill"
        case 600...623:
            return "cloud.snow.fill"
        default:
            return "cloud.fill"
        }
    }
}
