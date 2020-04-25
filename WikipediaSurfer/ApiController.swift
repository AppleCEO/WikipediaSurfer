//
//  JSONReceiver.swift
//  WikipediaSurfer
//
//  Created by joon-ho kil on 10/1/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ApiController {
    
    /// The shared instance
    static var shared = ApiController()
   
    /// API base URL
    let baseURLString = "https://en.wikipedia.org/w/api.php?action=opensearch&limit=10&namespace=0&format=json&search="
    
    init() {
      Logging.URLRequests = { request in
        return true
      }
    }
    
    enum ApiError: Error {
      case cityNotFound
      case serverFailure
      case invalidKey
    }
    
    func search(_ word: String) -> Observable<[String]> {
        return buildRequest(searchWord: word).map {
            $0.title
        }
    }
    
    //MARK: - Private Methods

  /**
   * Private method to build a request with RxCocoa
   */
    private func buildRequest(method: String = "GET", searchWord: String) -> Observable<Result> {
        
        let request: Observable<URLRequest> = Observable.create() { observer in
            let url = URL(string: self.baseURLString+searchWord)!
            var request = URLRequest(url: url)
            let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
            
            request.url = urlComponents.url!
            request.httpMethod = method
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            observer.onNext(request)
            observer.onCompleted()
            
            return Disposables.create()
        }
        let session = URLSession.shared
        
        return request.flatMap() { request in
            return session.rx.response(request: request).map() { response, data in
                if 200 ..< 300 ~= response.statusCode {
                    return try JSONDecoder().decode(Result.self, from: data)
                } else {
                    throw ApiError.serverFailure
                }
            }
        }
    }
    
    struct Result: Codable {
        let search: String
        let title: [String]
        let description: [String]
        let url: [String]
        
        init(from decoder: Decoder) throws {
            var unkeyedContainer = try decoder.unkeyedContainer()
            search = try unkeyedContainer.decode(String.self)
            title = try unkeyedContainer.decode([String].self)
            description = try unkeyedContainer.decode([String].self)
            url = try unkeyedContainer.decode([String].self)
        }
        
    }
}
