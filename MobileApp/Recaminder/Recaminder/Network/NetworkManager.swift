//
//  NetworkManager.swift
//  Recaminder
//
//  Created by timofey makhlay on 1/31/19.
//  Copyright © 2019 Timofey Makhlay. All rights reserved.
//

import UIKit

class NetworkManager {
    let urlSession = URLSession.shared
    var baseURL = "http://localhost:3000/"

    
    enum EndPoints {
        case health
        
        func getPath() -> String {
            switch self {
            case .health:
                return "/"
            }
        }
        
        func getHTTPMethod() -> String {
            return "GET"
        }
        
        func getHeaders() -> [String: String] {
            return [
                "Accept": "application/json",
                "Content-Type": "application/json",
//                "Host": "http://localhost:3000/"
            ]
        }
    }
    
    private func makeRequest(for endPoint: EndPoints) -> URLRequest {
        let path = endPoint.getPath()
        let fullURL = URL(string: baseURL)!
        var request = URLRequest(url: fullURL)
        request.httpMethod = endPoint.getHTTPMethod()
        request.allHTTPHeaderFields = endPoint.getHeaders()
        
        return request
    }
    
    enum Result<T> {
        case success(T)
        case failure(Error)
    }
    
    enum EndPointError: Error {
        case couldNotParse
        case noData
    }
    
    func getHealth(_ completion: @escaping (Result<Health>) -> Void) {
        let postsRequest = makeRequest(for: .health)
        let task = urlSession.dataTask(with: postsRequest) { data, response, error in
            // Check for errors.
            if let error = error {
                return completion(Result.failure(error))
            }
            
            // Check to see if there is any data that was retrieved.
            guard let data = data else {
                return completion(Result.failure(EndPointError.noData))
            }
            
            // Attempt to decode the data.
            guard let result = try? JSONDecoder().decode(Health.self, from: data) else {
                return completion(Result.failure(EndPointError.couldNotParse))
            }
//            print(result)
//            let posts = result.posts
            
            // Return the result with the completion handler.
            DispatchQueue.main.async {
                completion(Result.success(result))
            }
        }
        
        task.resume()
    }
}
