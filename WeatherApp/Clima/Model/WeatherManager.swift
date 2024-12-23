import CoreLocation
import Foundation



protocol weatherManagerDelegate {
    func weatherDidUpdate(weather: WeatherModel)
}

struct WeatherManager {
    
    var weatherURL: String = "https://api.openweathermap.org/data/2.5/weather?appid=f19d9464f99c6f674db431bf92af1c9b&units=metric"
    
    var delegate: weatherManagerDelegate?
    
    func completeWeatherURL(cityname: String) {
        let urlString: String = "\(weatherURL)&q=\(cityname)"
        performRequest(urlString: urlString)
    }
    
    func completeWeatherLatLon(lat: CLLocationDegrees, lon: CLLocationDegrees){
        let urlString: String = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(urlString: urlString)
    }
    
    func performRequest (urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let safeData = data {
                    if let weather = parseData(weatherData: safeData) {
                        self.delegate?.weatherDidUpdate(weather: weather)
                        
                    }
                }
            }
            task.resume()
        }
        
        func parseData(weatherData: Data) -> WeatherModel? {
            let decoder = JSONDecoder()
            do {
                let dataInfo = try decoder.decode(WeatherData.self, from: weatherData)
                let id = dataInfo.weather[0].id
                let temperature = dataInfo.main.temp
                let name = dataInfo.name
                let country = dataInfo.sys.country
                
                let weatherData = WeatherModel(cityId: id, cityTemperature: temperature, cityName: name, country: country)
                
                return weatherData
            } catch {
                print(error)
                return nil
            }
        }
    }
}


