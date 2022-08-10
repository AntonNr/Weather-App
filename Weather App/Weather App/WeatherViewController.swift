import Foundation
import UIKit
import CoreLocation

struct City: Codable {
    var name: String?
    let latitude, longitude: Double
}

struct ResultOfRequest: Codable {
    var results: [City]?
}

struct Weather: Codable {
    let latitude, longitude: Double
    let hourly: Hourly
}

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

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedCity: String = ""
    var latitude, longitude: Double?
    var weather: Weather?
    var locationManager = CLLocationManager()
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedCity == "My Location"{
            locationLabel.text = "My Location"
            loadUserLocation()
        } else {
            loadCityData()
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        loadUserLocation()
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.delegate = nil
    }
    
    func loadUserLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.headingFilter = 5.0
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func loadCityData() {
        let urlString: String = "https://geocoding-api.open-meteo.com/v1/search?name=\(selectedCity)&count=1"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) { request, data, error in
                if let data = data {
                    if let result: ResultOfRequest = try? JSONDecoder().decode(ResultOfRequest.self, from: data) {
                        
                        if (result.results == nil) {
                            let alertError = UIAlertController(title: "Error", message: "Failed to load the city you selected.", preferredStyle: .alert)
                            alertError.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(alertError, animated: true)
                        } else {
                            self.locationLabel.text = result.results?.first?.name
                            self.latitude = result.results?.first!.latitude
                            self.longitude = result.results?.first!.longitude
                            self.loadData()
                        }
                        
                        if let error = error {
                            let alertError = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                            self.present(alertError, animated: true)
                        }
                    }
                }
                
            }
            
        }
    }
    
    func loadData() {
        let urlString: String = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude ?? 0)&longitude=\(longitude ?? 0)&hourly=temperature_2m,relativehumidity_2m,windspeed_10m"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) { request, data, error in
                if let data = data {
                    if let results: Weather = try? JSONDecoder().decode(Weather.self, from: data) {
                            self.weather = results
                            self.tableView.reloadData()
                    }
                }
                
                if let error = error {
                    let alertError = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    self.present(alertError, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather?.hourly.time.count ?? 0
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as? WeatherTableViewCell {
            
            let currentTime =  weather?.hourly.time[indexPath.row]
            let currentTemperature = weather?.hourly.temperature2M[indexPath.row]
            let currentWindSpeed = weather?.hourly.windSpeed10M[indexPath.row]
            let currentHumidity = weather?.hourly.relativeHumidity2M[indexPath.row]
            
            cell.timeLabel.text = "\(currentTime!)"
            cell.temperatureLabel.text = "\(currentTemperature!)°"
            cell.windSpeedLabel.text = "\(currentWindSpeed!)km/h"
            cell.humidityLabel.text = "\(currentHumidity!)%"
                    
            return cell
        }
        return UITableViewCell()
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            loadData()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
}
