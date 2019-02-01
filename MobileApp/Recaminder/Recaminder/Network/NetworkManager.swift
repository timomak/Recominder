////
////  NetworkManager.swift
////  Recaminder
////
////  Created by timofey makhlay on 1/31/19.
////  Copyright © 2019 Timofey Makhlay. All rights reserved.
////
//
//import Foundation
//
//class NetworkManager {
//    let urlSession = URLSession.shared
//    var baseURL = "http://localhost:3000/"
////    var token = "03d3113b03aed2378d7bfb46d6706f5f02588936fbcac830dfed93946732aa75"
//    
//    enum EndPoints {
//        case data
//        
//        func getPath() -> String {
//            switch self {
//            case .data:
//                return "trainer-api/"
//            }
//        }
//        
//        func getHTTPMethod() -> String {
//            return "GET"
//        }
//        
////        func getHeaders(token: String) -> [String: String] {
////            return [
////                "Accept": "application/json",
////                "Content-Type": "application/json",
////                "Authorization": "Bearer \(token)",
////                "Host": "api.producthunt.com"
////            ]
////        }
//        
////        func getParams() -> [String: String] {
////            switch self {
////            case .data:
////                return [
////                    "sort_by": "votes_count",
////                    "order": "desc",
////                    "per_page": "20",
////
////                    "search[featured]": "true"
////                ]
////
////            case let .comments(postId):
////                return [
////                    "sort_by": "votes",
////                    "order": "asc",
////                    "per_page": "20",
////
////                    "search[post_id]": "\(postId)"
////                ]
////            }
////        }
//        
////        func paramsToString() -> String {
////            let parameterArray = getParams().map { key, value in
////                return "\(key)=\(value)"
////            }
////
////            return parameterArray.joined(separator: "&")
////        }
//    }
//    
//    private func makeRequest(for endPoint: EndPoints) -> URLRequest {
////        let stringParams = endPoint.paramsToString()
//        let path = endPoint.getPath()
////        let fullURL = URL(string: baseURL.appending(""))!
//        var request = URLRequest(url: baseURL)
//        request.httpMethod = endPoint.getHTTPMethod()
//        request.allHTTPHeaderFields = endPoint.getHeaders(token: token)
//        
//        return request
//    }
//    
//    enum Result<T> {
//        case success(T)
//        case failure(Error)
//    }
//    
//    enum EndPointError: Error {
//        case couldNotParse
//        case noData
//    }
//    
//    func getPosts(_ completion: @escaping (Result<[Post]>) -> Void) {
//        let postsRequest = makeRequest(for: .posts)
//        let task = urlSession.dataTask(with: postsRequest) { data, response, error in
//            // Check for errors.
//            if let error = error {
//                return completion(Result.failure(error))
//            }
//            
//            // Check to see if there is any data that was retrieved.
//            guard let data = data else {
//                return completion(Result.failure(EndPointError.noData))
//            }
//            
//            // Attempt to decode the data.
//            guard let result = try? JSONDecoder().decode(PostList.self, from: data) else {
//                return completion(Result.failure(EndPointError.couldNotParse))
//            }
//            
//            let posts = result.posts
//            
//            // Return the result with the completion handler.
//            DispatchQueue.main.async {
//                completion(Result.success(posts))
//            }
//        }
//        
//        task.resume()
//    }
//    
//    func getComments(_ postId: Int, completion: @escaping (Result<[Comment]>) -> Void) {
//        let commentsRequest = makeRequest(for: .comments(postId: postId))
//        let task = urlSession.dataTask(with: commentsRequest) { data, response, error in
//            if let error = error {
//                return completion(Result.failure(error))
//            }
//            
//            guard let data = data else {
//                return completion(Result.failure(EndPointError.noData))
//            }
//            
//            guard let result = try? JSONDecoder().decode(CommentApiResponse.self, from: data) else {
//                return completion(Result.failure(EndPointError.couldNotParse))
//            }
//            
//            DispatchQueue.main.async {
//                completion(Result.success(result.comments))
//            }
//        }
//        
//        task.resume()
//    }
//}
