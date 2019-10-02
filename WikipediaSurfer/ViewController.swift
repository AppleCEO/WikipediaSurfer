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

class ViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    var searchResult: Observable<SearchResult>?
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        searchResult = JSONReceiver.getJson(search: "Hello world")
        searchResult?
            .subscribe(onNext: { element in
                dump(element)
            })
            .disposed(by: disposeBag)
    }
}
