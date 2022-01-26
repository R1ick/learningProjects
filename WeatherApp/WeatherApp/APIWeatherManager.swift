//
//  APIWeatherManager.swift
//  WeatherApp
//
//  Created by Ярослав Антонович on 06.01.2022.
//

import Foundation

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

enum ForecastType: FinalURLPointProtocol {
    case Current(apiKey: String, coordinates: Coordinates)
    
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org")!
    }
    var path: String {
        switch self {
        case .Current(let apiKey, let coordinates):
            return "/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(apiKey)"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo:  baseURL)
        return URLRequest(url: url!)
    }
}



final class APIWeatherManager: APIManagerProtocol {    
    func fetch<T>(request: URLRequest, parse: @escaping ([String : AnyObject]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) {
        let dataTask = JSONTaskWith(request: request) { (json, response, error) in
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completionHandler(.failure(error))
                    }
                    return
                }
                if let value = parse(json) {
                    completionHandler(.success(value))
                } else {
                    let error = NSError(domain: SWINetworkingErrorDomain, code: 200, userInfo: nil)
                    completionHandler(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
    
    func JSONTaskWith(request: URLRequest, completionHandler: @escaping ([String : AnyObject]?, HTTPURLResponse?, Error?) -> Void) -> JSONTask {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let HTTPResponse = response as? HTTPURLResponse else {
                
                let userInfo = [
                    NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")]
                let error = NSError(domain: SWINetworkingErrorDomain, code: missingHTTPResponseError, userInfo: userInfo)
                completionHandler(nil, nil, error)
                return
            }
            if data == nil {
                if let error = error {
                    completionHandler(nil, HTTPResponse, error)
                }
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                        completionHandler(json, HTTPResponse, nil)
                    } catch let error as NSError {
                        completionHandler(nil, HTTPResponse, error)
                    }
                default:
                    print("We have got response status \(HTTPResponse.statusCode)")
                }
            }
        }
        return dataTask
    }
    

    let sessionConfiguration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    } ()
    let apiKey: String

    init(sessionConfiguration: URLSessionConfiguration, apiKey: String) {
        self.sessionConfiguration = sessionConfiguration
        self.apiKey = apiKey
    }
    
    convenience init(apiKey: String) {
        self.init(sessionConfiguration: URLSessionConfiguration.default, apiKey: apiKey)
    }
    
    func fetchCurrentWeatherWith(coordinates: Coordinates, completionHandler: @escaping (APIResult<CurrentWeather>) -> Void) {
        let request = ForecastType.Current(apiKey: self.apiKey, coordinates: coordinates).request
        
        fetch(request: request, parse: { (json) -> CurrentWeather? in
            if let dictionary = json["main"] as? [String: AnyObject] {
                return CurrentWeather(JSON: dictionary)
            } else {
                return nil
            }
        }, completionHandler: completionHandler)
    }
}


