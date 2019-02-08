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
    var baseURL = "https://recominder-api.herokuapp.com/api/auth"

    
    enum EndPoints {
        case health
        case signup
        case login
        case healthKitData
        
        func getPath() -> String {
            switch self {
            case .health:
                return "/"
            case .signup:
                // This is a post route. Email & Password
                return "/register"
            case .login:
                // This is a post route. Email & Password
                return "/login"
            case .healthKitData:
                return "/data"
            }
        }
        
        func getHTTPMethod() -> String {
            return "GET"
        }
        
        func postHTTPMethod() -> String {
            return "POST"
        }
        
        func getHeaders() -> [String: String] {
            return [
                "Accept": "application/json",
                "Content-Type": "application/json",
//                "nToken": "\()"
//                "Host": "https://recominder-api.herokuapp.com/api/auth"
            ]
        }
    }
    
    private func makeGetRequest(for endPoint: EndPoints) -> URLRequest {
        let path = endPoint.getPath()
        let fullURL = URL(string: baseURL)!
        var request = URLRequest(url: fullURL)
        request.httpMethod = endPoint.getHTTPMethod()
        request.allHTTPHeaderFields = endPoint.getHeaders()
        
        return request
    }
    
    private func makePostRequest(for endPoint: EndPoints) -> URLRequest {
        let path = endPoint.getPath()
        let fullURL = URL(string: baseURL.appending(path))!
        var request = URLRequest(url: fullURL)
        request.httpMethod = endPoint.postHTTPMethod()
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
        let postsRequest = makeGetRequest(for: .health)
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
    
    func signUpPost(_ email: String,_ password: String,_ completion: @escaping (Result<String>) -> Void) {
        var signupRequest = makePostRequest(for: .signup)
        
        let data = ["email":"\(email)","password":"\(password)"]
        let jsonData = try? JSONEncoder().encode(data)
//        let jsonString = String(data: jsonData!, encoding: .utf8)!
        
        signupRequest.httpBody = jsonData
        
        let task = urlSession.dataTask(with: signupRequest) { data, response, error in
            // Check for errors.
            if let error = error {
                return completion(Result.failure(error))
            }
            
            // Check to see if there is any data that was retrieved.
            guard let data = data else {
                return completion(Result.failure(EndPointError.noData))
            }
            
            // Attempt to decode the data.
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) else {
                return completion(Result.failure(EndPointError.couldNotParse))
            }
            
            
            if let result = result as? [String: Any] {
                print("response Sign up",result)
            }
            
            // Return the result with the completion handler.
            DispatchQueue.main.async {
                completion(Result.success("WORKED SIGN UP"))
            }
        }
        
        task.resume()
    }
    
    func logInPost(_ email: String,_ password: String,_ completion: @escaping (Result<String>) -> Void) {
        var loginRequest = makePostRequest(for: .login)
        
        let data = ["email":"\(email)","password":"\(password)"]
        let jsonData = try? JSONEncoder().encode(data)
        
        loginRequest.httpBody = jsonData
        
        let task = urlSession.dataTask(with: loginRequest) { data, response, error in
            // Check for errors.
            if let error = error {
                return completion(Result.failure(error))
            }
            
            // Check to see if there is any data that was retrieved.
            guard let data = data else {
                return completion(Result.failure(EndPointError.noData))
            }
            
            // Attempt to decode the data.
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) else {
                return completion(Result.failure(EndPointError.couldNotParse))
            }
            
            
            if let result = result as? [String: Any] {
                print("response Login",result)
            }
            
            // Return the result with the completion handler.
            DispatchQueue.main.async {
                completion(Result.success("WORKED LOG IN"))
            }
        }
        
        task.resume()
    }
    
    func postHeartData(_ jsonData: Data,_ completion: @escaping (Result<String>) -> Void) {
        var loginRequest = makePostRequest(for: .healthKitData)
        
        loginRequest.httpBody = jsonData

        let task = urlSession.dataTask(with: loginRequest) { data, response, error in
            // Check for errors.
            if let error = error {
                return completion(Result.failure(error))
            }
            
            // Check to see if there is any data that was retrieved.
            guard let data = data else {
                return completion(Result.failure(EndPointError.noData))
            }

//            // Attempt to decode the data.
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) else {
                return completion(Result.failure(EndPointError.couldNotParse))
            }
            
            if let result = result as? [String: Any] {
                print("Response: ",result)
            }
//
//            if let result = result as? [String: Any] {
//                print("response Login",result)
//            }
            
            // Return the result with the completion handler.
            DispatchQueue.main.async {
                completion(Result.success("WORKED DATA PUSH"))
            }
        }
        
        task.resume()
    }
}
