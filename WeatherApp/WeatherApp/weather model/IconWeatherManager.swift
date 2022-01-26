//
//  IconWeatherManager.swift
//  WeatherApp
//
//  Created by Ярослав Антонович on 06.01.2022.
//

import Foundation
import UIKit

enum WeatherIconManager: String {
    case clearDay = "clear-day"
    case clearNight = "clear-night"
    case rain = "rain"
    case snow = "snow"
    case sleet = "sleet"
    case wind = "wind"
    case fog = "fog"
    case cloudy = "cloudy"
    case partlyCloudyDay = "partly-cloudy-day"
    case partlyCloudyNight = "partly-cloudy-night"
    case unprediictedIcon = "unpredicted-icon"
    
    init(rawValue: String) {
        switch rawValue {
        case "clear-day": self = .clearDay
        case "clear-night": self = .clearNight
        case "rain": self = .rain
        case "snow": self = .snow
        case "sleet": self = .sleet
        case "wind": self = .wind
        case "fog": self = .fog
        case "cloudy": self = .cloudy
        case "partly-cloudy-day": self = .partlyCloudyDay
        case "partly-cloudy-night": self = .partlyCloudyNight
        default: self = .unprediictedIcon
        }
    }
}

extension WeatherIconManager {
    var image: UIImage {
        return UIImage(named: self.rawValue)!
    }
}
