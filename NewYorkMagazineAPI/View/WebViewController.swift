//
//  WebViewController.swift
//  NewYorkMagazineAPI
//
//  Created by Sihan Fang on 2019/1/25.
//  Copyright © 2019 Sihan Fang. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    
    var url = URL(string: "https://www.instapaper.com/u")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlRequest = URLRequest(url: url!)
        
        webView.navigationDelegate = self
        webView.load(urlRequest)
    }

}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
}


