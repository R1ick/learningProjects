//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ярослав Антонович on 05.01.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var appearentTemperatureLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let locationManager = CLLocationManager()
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        toggleActivityIndicator(on: true)
        getCurrentWeatherData()
    }
    
    func toggleActivityIndicator(on: Bool) {
        refreshButton.isHidden = on
        if on {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    lazy var weatherManager = APIWeatherManager(apiKey: "8a7fc5a4db3a0c6d6b9d07f3f1a6aec0")
    let coordinates = Coordinates(latitude: 53.89542021690432, longitude: 27.556383176775217)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        getCurrentWeatherData()
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let userLocation = locations.last! as CLLocation
//        print("\n\n\n\n\n\n\n\n\n\n\n")
//        print("my location latitude: \(userLocation.coordinate.latitude) , longitude: \(userLocation.coordinate.longitude) ")
//    }
//
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last! as CLLocation
        print("my location latitude: \(userLocation.coordinate.latitude) , longitude: \(userLocation.coordinate.longitude) ")
    }
    func getCurrentWeatherData() {
        weatherManager.fetchCurrentWeatherWith(coordinates: coordinates) { (result) in
            self.toggleActivityIndicator(on: false)
            switch result {
            case .success(let currentWeather):
                self.updateUIWithCurrentWeather(currentWeather: currentWeather)
            case .failure(let error as NSError):
                let alertController = UIAlertController(title: "Unabel to get data", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func updateUIWithCurrentWeather(currentWeather: CurrentWeather) {
        self.imageView.image = currentWeather.icon
        self.pressureLabel.text = currentWeather.pressureString
        self.temperatureLabel.text = currentWeather.temperatureString
        self.appearentTemperatureLabel.text = "Feels like \(currentWeather.appearentTemperatureString)"
        self.humidityLabel.text = currentWeather.humidityString
    }
    
    
}


