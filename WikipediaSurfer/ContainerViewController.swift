//
//  ContainerViewController.swift
//  WikipediaSurfer
//
//  Created by joon-ho kil on 2020/01/03.
//  Copyright © 2020 길준호. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class ContainerViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
    @IBOutlet weak var containerView: ContainerView!
    var url: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.setWebViewNavigationDelegate(viewController: self)
        containerView.webViewLoad(url: url)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
}
