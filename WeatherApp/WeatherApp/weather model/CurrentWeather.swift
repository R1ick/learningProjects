//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Ярослав Антонович on 06.01.2022.
//

import Foundation
import UIKit

struct CurrentWeather {
    let temperature: Double
    let appearentTemperature: Double
    let humidity: Double
    let pressure: Double
    let icon: UIImage
}

extension CurrentWeather: JSONDecodableProtocol {
    init?(JSON: [String : AnyObject]) {
        guard let temperature = JSON["temp"] as? Double,
              let appearentTemperature = JSON["feels_like"] as? Double,
              let humidity = JSON["humidity"] as? Double,
              let pressure = JSON["pressure"] as? Double else {
                  return nil
              }
//        let icon = WeatherIconManager(rawValue: iconString).image
        self.temperature = temperature
        self.appearentTemperature = appearentTemperature
        self.humidity = humidity
        self.pressure = pressure
        self.icon = UIImage(named: "clear-day")!
//        self.icon = icon
              
    }
}

extension CurrentWeather {
    var pressureString: String {
        return "\(Int(pressure * 0.750062)) mm"
    }
    var humidityString: String {
        return "\(Int(humidity))%"
    }
    var temperatureString: String {
        return "\(Int(temperature - 273))˚C"
    }
    var appearentTemperatureString: String {
        return "\(Int(appearentTemperature - 273))˚C"
    }
}
