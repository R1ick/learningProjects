//
//  APIManager.swift
//  WeatherApp
//
//  Created by Ярослав Антонович on 06.01.2022.
//

import Foundation

typealias JSONTask = URLSessionDataTask
typealias JSONCompletionHandler = ([String: AnyObject]?, HTTPURLResponse?, Error?) -> Void

protocol JSONDecodableProtocol {
    init?(JSON: [String:AnyObject])
}

protocol FinalURLPointProtocol {
    var baseURL: URL { get }
    var path: String { get }
    var request: URLRequest { get }
}

enum APIResult<T> {
    case success(T)
    case failure(Error)
}

protocol APIManagerProtocol {
    var sessionConfiguration: URLSessionConfiguration { get }
    var session: URLSession { get }
//
//    func JSONTaskWith(request: URLRequest, completionHandler: JSONCompletionHandler) -> JSONTask
//    func fetch<T>(request: URLRequest, parse: ([String: AnyObject]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void )
}

//extension APIManagerProtocol {
//    func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask {
//        let dataTask = session.dataTask(with: request) { (data, response, error) in
//            guard let HTTPResponse = response as? HTTPURLResponse else {
//                
//                let userInfo = [
//                    NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")]
//                let error = NSError(domain: SWINetworkingErrorDomain, code: missingHTTPResponseError, userInfo: userInfo)
//                completionHandler(nil, nil, error)
//                return
//            }
//            if data == nil {
//                if let error = error {
//                    completionHandler(nil, HTTPResponse, error)
//                }
//            } else {
//                switch HTTPResponse.statusCode {
//                case 200:
//                    do {
//                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
//                        completionHandler(json, HTTPResponse, nil)
//                    } catch let error as NSError {
//                        completionHandler(nil, HTTPResponse, error)
//                    }
//                default:
//                    print("We have got response status \(HTTPResponse.statusCode)")
//                }
//            }
//        }
//        return dataTask
//    }
//    func fetch<T: JSONDecodableProtocol>(request: URLRequest, parse: @escaping ([String: AnyObject]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void ) {
//        let dataTask = JSONTaskWith(request: request) { (json, response, error) in
//            DispatchQueue.main.async {
//                guard let json = json else {
//                    if let error = error {
//                        completionHandler(.failure(error))
//                    }
//                    return
//                }
//                if let value = parse(json) {
//                    completionHandler(.success(value))
//                } else {
//                    let error = NSError(domain: SWINetworkingErrorDomain, code: 200, userInfo: nil)
//                    completionHandler(.failure(error))
//                }
//            }
//        }
//        dataTask.resume()
//    }
//}
