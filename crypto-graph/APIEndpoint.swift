//
//  APIService.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 26.02.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit

struct CoinMarketCapAPI {
    private static let baseURLString: String = "https://api.coinmarketcap.com/v1"

    static func buildURL(for action: RequestAction, with parameters: [String:String]? = nil) -> URL {

        let urlString = "\(baseURLString)/\(action.getString())"
        var components = URLComponents(string: urlString)!
        var queryItems = [URLQueryItem]()

        parameters?.forEach { key, value in
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }

        components.queryItems = queryItems

        return components.url!
    }
}

class APIEndpoint {

    private let coreDataManager: CoreDataManager = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.coreDataManager!
    }()

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()

    private func request(_ url: URL, method: RequestMethod = .get, parameters: [String: String], completion: @escaping (Result<[[String: Any]]>) -> Void) {
        var request = URLRequest(url: url)
            request.httpMethod = method.rawValue

        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in

            guard let data = data else {
                return completion(.failure(.undefinedError))
            }

            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [[String: Any]] else {
                    return completion(.failure(.invalidJSONFormat))
                }

                DispatchQueue.main.async {
                    completion(.success(json))
                }
            } catch {
                completion(.failure(.invalidJSONFormat))
            }
        }
        task.resume()
    }

    final func request<T: ManagedObjectJSONInitializable>(action: RequestAction, parameters: [String: String] = [:], success: @escaping ([T]) -> Void, failure: @escaping (RequestError) -> Void) {

        let url = CoinMarketCapAPI.buildURL(for: action, with: parameters)
        request(url, parameters: parameters) { response in
            switch response {
            case let .success(jsonArray):
                var objects: [T] = []
                for json in jsonArray {
                    guard let obj = T(in: self.coreDataManager.context, with: json) else {
                        failure(.invalidJSONCorresponding)
                        return
                    }
                    objects.append(obj)
                }

                self.coreDataManager.save()
                success(objects)
            case let .failure(error):
                failure(error)
            }
        }
    }

    final func cancellAllTasks() {
        session.getAllTasks {
            tasks in
            tasks.forEach({ $0.cancel() })
        }
    }
}

enum RequestMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

enum RequestAction {
    case ticker
    case tickerWith(id: String)
    case global

    func getString() -> String {
        switch self {
        case .ticker: return "ticker"
        case .global: return "global"
        case let .tickerWith(id: id):
            return "ticker/\(id)"
        }
    }
}

enum Result<T> {
    case success(T)
    case failure(RequestError)
}

enum RequestError: Error {
    case invalidJSONFormat
    case undefinedError
    case invalidJSONCorresponding
}
