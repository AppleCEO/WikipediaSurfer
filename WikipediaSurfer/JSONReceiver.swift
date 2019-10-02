//
//  JSONReceiver.swift
//  WikipediaSurfer
//
//  Created by joon-ho kil on 10/1/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import Foundation
import RxSwift

struct JSONReceiver {
    static func getJson(search: String) -> Observable<SearchResult> {
        var searchResult = SearchResult()
    
        let result = Observable.just(search)
            .map {
                $0.replacingOccurrences(of: " ", with: "%20")
            }
            .map {
             "https://en.wikipedia.org/w/api.php?action=opensearch&limit=10&namespace=0&format=json&search=" + $0
            }.compactMap {
                URL(string: $0)
            }.map { urlString in
                Observable<SearchResult>.create { observable in
                    let task = URLSession.shared.dataTask(with: urlString) { (data, response, error) in
                        guard let data = data else {
                            print("load data failed")
                            return
                        }
                        
                        let decoder: JSONDecoder = JSONDecoder()
                        do {
                            searchResult =  try decoder.decode(SearchResult.self, from: data)
                            observable.onNext(searchResult)
                            observable.onCompleted()
                        } catch {
                            observable.onError(error)
                        }
                    }
                    task.resume()
                    return Disposables.create()
                }
            }.flatMap { $0 }

        return result
    }
}
