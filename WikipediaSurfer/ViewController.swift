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
    var recentSearches = [(String,Date)]()
    var searchResult: SearchResult?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func search(_ searchText: String) {
        searchOb = JSONReceiver.getJson(search: searchText)
        searchOb?
            .subscribe(onNext: { element in
                self.searchResult = element
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
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
            cell.textLabel?.text = searchResult?.title[indexPath.row]
            cell.detailTextLabel?.text = nil
            return cell
        }
        
        let reverseRow = recentSearches.count-indexPath.row-1
        cell.textLabel?.text = recentSearches[reverseRow].0
        
        let dateString = DateConverter.dateToString(date: recentSearches[reverseRow].1)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let searchText = searchBar.text else {
            return
        }
        
        guard searchText != "" else {
            let reverseRow = recentSearches.count-indexPath.row-1
            searchBar.text = recentSearches[reverseRow].0
            search(recentSearches[reverseRow].0)
            return
        }
        
        let urlString = searchResult?.url[indexPath.row]
        
        
        while recentSearches.count >= 10 {
            recentSearches.remove(at: 0)
        }
            
        recentSearches.append((searchText, Date()))
        
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

            tableView.reloadData()
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
            tableView.reloadData()
            return
        }
        
        search(searchText)
    }
}
