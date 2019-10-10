//
//  ViewController.swift
//  WikipediaSurfer
//
//  Created by joon-ho kil on 10/1/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchOb: Observable<SearchResult>?
    var recentSearches = [RecentSearch]()
    var searchResult: SearchResult?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRecentSearches()
    }
    
    func search(_ searchText: String) {
        searchOb = JSONReceiver.getJson(search: searchText)
        searchOb?
            .subscribe(onNext: { element in
                self.searchResult = element
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet.init(integersIn: 0...0), with: UITableView.RowAnimation.automatic)
                }
            })
            .disposed(by: disposeBag)
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

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchText = searchBar.text, searchText != "" {
            return searchResult?.title.count ?? 0
        }
        
        return recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let searchText = searchBar.text, searchText != "" {
            let title = searchResult?.title[indexPath.row] ?? ""
            let attributedString = NSMutableAttributedString(string: title)
            let sameCharactorLength = getSameCharactorLength(searchText, title)
            
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange, range: NSRange(location: 0, length: sameCharactorLength))
            
            cell.textLabel?.attributedText = attributedString
            cell.detailTextLabel?.text = nil
            return cell
        }
        
        let reverseRow = recentSearches.count-indexPath.row-1
        cell.textLabel?.text = recentSearches[reverseRow].title
        
        let dateString = DateConverter.dateToString(date: recentSearches[reverseRow].date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let searchText = searchBar.text else {
            return
        }
        
        guard searchText != "" else {
            let reverseRow = recentSearches.count-indexPath.row-1
            searchBar.text = recentSearches[reverseRow].title
            search(recentSearches[reverseRow].title)
            return
        }
        
        let urlString = searchResult?.url[indexPath.row]
        
        while recentSearches.count >= 10 {
            recentSearches.remove(at: 0)
        }
            
        recentSearches.append(RecentSearch(title: searchText, date: Date()))
        saveRecentSearches()
        
        if let url = URL(string: urlString ?? "www.apple.com") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let searchText = searchBar.text, searchText != "" {
            return nil
        }
        
        return "최근 검색 기록"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let reverseRow = recentSearches.count-indexPath.row-1
            recentSearches.remove(at: reverseRow)
            saveRecentSearches()

            tableView.reloadSections(IndexSet.init(integersIn: 0...0), with: UITableView.RowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchResult = nil
            tableView.reloadSections(IndexSet.init(integersIn: 0...0), with: UITableView.RowAnimation.automatic)
            return
        }
        
        search(searchText)
    }
}
