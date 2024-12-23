import UIKit
import CoreLocation


protocol weatherDidUpdateManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    )
}

class WeatherViewController: UIViewController{

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    
    var delegate = weatherDidUpdateManagerDelegate?.self
    
    var weatherManager = WeatherManager()
    let coreLocation = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrentWeather()
        
        weatherManager.delegate = self
        cityTextField.delegate = self

    }
    
    @IBAction func GetActualLocationButton(_ sender: UIButton) {
        getCurrentWeather()
    }
    
    func getCurrentWeather() {
        coreLocation.delegate = self
        coreLocation.requestWhenInUseAuthorization()
        coreLocation.requestLocation()

        func weatherDidUpdate(weather: WeatherModel) {
            DispatchQueue.main.async {
                self.temperatureLabel.text = weather.cityTemperatureString
                self.conditionImageView.image = UIImage(systemName: weather.conditionName)
                self.cityLabel.text = weather.cityName
            }
        }
    }
    
}

//MARK: -UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        cityTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if cityTextField.text != "" {
            return true
        } else {
            cityTextField.placeholder = "Complete the field"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let weather = cityTextField.text {
            weatherManager.completeWeatherURL(cityname: weather)
        }
        
        cityTextField.text = ""
    }
  
}

//MARK: -weatherManagerDelegate


extension WeatherViewController: weatherManagerDelegate {
    
    func weatherDidUpdate(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.cityTemperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
}

//MARK: -weatherDidActuallyLocation

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let actuallyLocation = locations.last {
            coreLocation.stopUpdatingLocation()
            let latitude = actuallyLocation.coordinate.latitude
            let longitude = actuallyLocation.coordinate.longitude
            weatherManager.completeWeatherLatLon(lat: latitude, lon: longitude)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Opps. Error here!")
    }
}
