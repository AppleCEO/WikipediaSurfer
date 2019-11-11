//
//  ViewModel.swift
//  WikipediaSurfer
//
//  Created by joon-ho kil on 2019/11/06.
//  Copyright © 2019 길준호. All rights reserved.
//

import Foundation
import RxSwift

class ViewModel {
    var searchMode: Observable<Bool> = Observable.just(false)
    var recentSearches = [RecentSearch]()
    var searchResult: SearchResult?
    
    init() {
        loadRecentSearches()
    }
    
    func setKeywordText(_ keyword: String) {
        if keyword == "" {
            searchMode = Observable.just(false)
//            search(keyword)
            return
        }
        
        searchMode = Observable.just(true)
    }
    
    func search(_ searchText: String) {
        let searchOb = JSONReceiver.getJson(search: searchText)
        searchOb
            .subscribe(onNext: { element in
                self.searchResult = element
            })
            .dispose()
    }
    
    func getSameCharactorLength(_ first: String, _ second: String) -> Int {
        var sameCharactorLength = 0
        var shortCharactorLength = first.count
        let firstCharactors = Array(first)
        let secondCharactors = Array(second)
        
        if shortCharactorLength > second.count {
            shortCharactorLength = second.count
        }
        
        for index in 0..<shortCharactorLength {
            if firstCharactors[index].uppercased() == secondCharactors[index].uppercased() {
                sameCharactorLength+=1
            }
        }
        
        return sameCharactorLength
    }
    
    func saveRecentSearches(){
        UserDefaults.standard.set(try? PropertyListEncoder().encode(recentSearches), forKey: "recentSearches")
    }
    
    func loadRecentSearches() {
        if let data = UserDefaults.standard.object(forKey: "recentSearches") as? Data {
            
            recentSearches = try! PropertyListDecoder().decode([RecentSearch].self, from: data)
        }
    }
}
