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
    var searchResult: SearchResult?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult?.title.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = searchResult?.title[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentRowOfList = searchResult?.url[indexPath.row]
        
        if let url = URL(string: currentRowOfList ?? "www.apple.com") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
