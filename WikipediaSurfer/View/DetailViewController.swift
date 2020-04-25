//
//  DetailViewController.swift
//  WikipediaSurfer
//
//  Created by joon-ho kil on 2019/11/11.
//  Copyright © 2019 길준호. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    private var searchResult: SearchResult!
    private var index = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ContainerViewController
        destination.url = searchResult.url[index]
    }
    
    func referToSearchResult (_ searchResult: SearchResult, index: Int) {
        self.searchResult = searchResult
        self.index = index
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = searchResult.title[index]
        descriptionLabel.text = searchResult.description[index]
        urlLabel.text = searchResult.url[index]
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
