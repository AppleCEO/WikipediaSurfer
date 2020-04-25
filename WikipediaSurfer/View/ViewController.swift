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

typealias Result = ApiController.Result

class ViewController: UIViewController {
    @IBOutlet weak var searchWord: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var recentSearches = [RecentSearch]()
    var disposeBag = DisposeBag()
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRecentSearches()
        
        let searchInput = searchWord.rx.controlEvent(.editingDidEndOnExit).asObservable()
        .map { self.searchWord.text }
        .filter { ($0 ?? "").count > 0 }
        
        let textSearch = searchInput.flatMap { text in
          return ApiController.shared.search(text ?? "Error")
        }
        
        textSearch.bind(to: tableView.rx.items) { (tableView: UITableView, index: Int, element: String) -> UITableViewCell in
                let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
                cell.textLabel?.text = element
                return cell
            }
        .disposed(by: disposeBag)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destination = segue.destination as! DetailViewController
//        if let searchResult = searchResult {
//            destination.referToSearchResult(searchResult, index: index)
//        }
//    }
//
//    func search(_ searchText: String) {
//        disposeBag = DisposeBag()
//        searchOb = JSONReceiver.getJson(search: searchText)
//        searchOb?
//            .subscribe(onNext: { element in
//                self.searchResult = element
//                DispatchQueue.main.async {
//                    self.tableView.reloadSections(IndexSet.init(integersIn: 0...0), with: UITableView.RowAnimation.automatic)
//                }
//            })
//            .disposed(by: disposeBag)
//    }
    
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

//extension ViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let searchText = searchWord.text, searchText != "" {
//            return searchResult?.title.count ?? 0
//        }
//        
//        return recentSearches.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        
//        if let searchText = searchWord.text, searchText != "" {
//            let title = searchResult?.title[indexPath.row] ?? ""
//            let attributedString = NSMutableAttributedString(string: title)
//            let sameCharactorLength = getSameCharactorLength(searchText, title)
//        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange, range: NSRange(location: 0, length: sameCharactorLength))
//            
//            cell.textLabel?.attributedText = attributedString
//            cell.detailTextLabel?.text = nil
//            
//            return cell
//        }
//        
//        let reverseRow = recentSearches.count-indexPath.row-1
//        cell.textLabel?.text = recentSearches[reverseRow].title
//        
//        let dateString = DateConverter.dateToString(date: recentSearches[reverseRow].date)
//        cell.detailTextLabel?.text = dateString
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let searchText = searchWord.text else {
//            return
//        }
//        view.endEditing(true)
//        
//        guard searchText != "" else {
//            let reverseRow = recentSearches.count-indexPath.row-1
//            searchWord.text = recentSearches[reverseRow].title
//            search(recentSearches[reverseRow].title)
//            return
//        }
//        
//        while recentSearches.count >= 10 {
//            recentSearches.remove(at: 0)
//        }
//            
//        recentSearches.append(RecentSearch(title: searchText, date: Date()))
//        saveRecentSearches()
//        
//        index = indexPath.row
//        self.performSegue(withIdentifier: "moveToDetail", sender: self)
//    }
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if let searchText = searchWord.text, searchText != "" {
//            return nil
//        }
//        
//        return "Recent"
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == .delete) {
//            let reverseRow = recentSearches.count-indexPath.row-1
//            recentSearches.remove(at: reverseRow)
//            saveRecentSearches()
//
//            tableView.reloadSections(IndexSet.init(integersIn: 0...0), with: UITableView.RowAnimation.automatic)
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt
//        indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        if let searchText = searchWord.text, searchText == "" {
//            return .delete
//        }
//        
//        return .none
//    }
//}
//
//extension ViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText == "" {
//            searchResult = nil
//            view.endEditing(true)
//            tableView.reloadSections(IndexSet.init(integersIn: 0...0), with: UITableView.RowAnimation.automatic)
//            return
//        }
//        
//        search(searchText)
//    }
//}
