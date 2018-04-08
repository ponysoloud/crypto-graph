//
//  APIService.swift
//  crypto-graph
//
//  Created by Александр Пономарев on 26.02.18.
//  Copyright © 2018 Base team. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import CoreData

class APIEndpoint {

    /*
     private let coreDataManager: CoreDataManager = {
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     return appDelegate.coreDataManager!
     }() */

    var baseURL: String {
        return ""
    }

    var mapper: Mapper? {
        return nil
    }

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()

    private func buildURL(path: String? = nil, parameters: [String:String]? = nil) -> URL? {

        var urlString = "\(baseURL)"

        if let path = path {
            urlString.append("/\(path)")
        }

        var components = URLComponents(string: urlString)!
        var queryItems = [URLQueryItem]()

        parameters?.forEach { key, value in
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }

        components.queryItems = queryItems
        print(components.url!)
        return components.url
    }

    private func request(_ url: URL, method: RequestMethod = .get, parameters: [String: String], completion: @escaping (RequestResult<Data>) -> Void) {

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in

            guard let data = data, error == nil else {
                return completion(.failure(.undefinedError))
            }

            return completion(.success(data))
        }
        task.resume()
    }

    private func requestJSON(_ url: URL, method: RequestMethod = .get, parameters: [String: String], completion: @escaping (RequestResult<JSON>) -> Void) {

        request(url, method: method, parameters: parameters) { response in
            switch response {
            case let .success(data):
                do {
                    let json = try JSON(data: data)
                    return completion(.success(json))
                } catch {
                    return completion(.failure(.invalidJSONFormat))
                }
            case let .failure(error):
                return completion(.failure(error))
            }
        }
    }

    final func request<T: Mappable>(path: String, parameters: [String: String] = [:], success: @escaping (T) -> Void, failure: @escaping (RequestError) -> Void) {

        guard let url = buildURL(path: path, parameters: parameters) else {
            return failure(.invalidURL)
        }

        requestJSON(url, parameters: parameters) { response in
            switch response {
            case let .success(json):

                let completion: (T?) -> Void = {
                    guard let obj = $0 else {
                        failure(.invalidJSONCorresponding)
                        return
                    }
                    success(obj)
                }

                self.mapper?.map(json: json, completion: completion)
            case let .failure(error):
                failure(error)
            }
        }
    }

    final func request<T: Mappable>(path: String, parameters: [String: String] = [:], success: @escaping ([T]) -> Void, failure: @escaping (RequestError) -> Void) {

        guard let url = buildURL(path: path, parameters: parameters) else {
            return failure(.invalidURL)
        }

        requestJSON(url, parameters: parameters) { response in
            switch response {
            case let .success(json):
                let count = json.arrayValue.count

                let succ: ([T]) -> Void = { p in
                    DispatchQueue.main.async {
                        success(p)
                    }
                }
                let blocks = ConcurrentBlocksArray(count: count, end: succ)

                let completion: (T?) -> Void = {
                    guard let obj = $0 else {
                        failure(.invalidJSONCorresponding)
                        return
                    }
                    blocks.add(result: obj)
                }

                json.arrayValue.forEach {
                    self.mapper?.map(json: $0, completion: completion)
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    }

    final func cancelAllTasks() {
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

enum RequestResult<T> {
    case success(T)
    case failure(RequestError)
}

enum RequestError: Error {
    case invalidJSONFormat
    case undefinedError
    case invalidJSONCorresponding
    case invalidURL
}
