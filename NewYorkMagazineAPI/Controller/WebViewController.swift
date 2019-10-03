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
//    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    var currentNews: Article?
//    var savedNews =  [Article]()
    
    var url = URL(string: "https://www.instapaper.com/u")
    
    var saveButton: UIBarButtonItem?
    var shareButton: UIBarButtonItem?
    
    let savedNewsModel = SavedNewsViewModel()
    
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = url {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
        
        navigationItem.title = "News"
        webView.navigationDelegate = self
        
        
        savedNewsModel.savedArticles.bind { (art) in
            print(art, "printed from webcontroller")
            print("the number of savedNews from web is \(self.savedNewsModel.savedArticles.value.count)")
            
        }
        setupNavButtons()
    }
    
    func setupNavButtons() {
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleShare))
        if let saveButton = saveButton, let shareButton = shareButton {
            navigationItem.rightBarButtonItems = [saveButton, shareButton]
        }
        
        guard currentNews != nil else {return}
        for art in savedNewsModel.savedArticles.value {
            if art.title == currentNews!.title {
                saveButton?.isEnabled = false
            } else {
                saveButton?.isEnabled = true
            }
        }
        
    }
    @objc func handleShare() {
        guard let newsURL = currentNews?.url else {return}
        let shareNews = "Check out this news: \(newsURL)"
        let activityController = UIActivityViewController(activityItems: [shareNews], applicationActivities: nil)
        self.present(activityController, animated: true)
    
    }
    @objc func handleSave() {
        savedNewsModel.saveArticle(currentNews)
//        NotificationCenter.default.post(name: .newsRadio, object: self)
        let alert = UIAlertController(title: "Saved", message: "News Saved Successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

}

extension WebViewController: WKNavigationDelegate {
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
//        if let saveButton = saveButton, let shareButton = shareButton {
//            saveButton.isEnabled = false
//            shareButton.isEnabled = false
//        }
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
//        if let saveButton = saveButton, let shareButton = shareButton {
//            saveButton.isEnabled = true
//            shareButton.isEnabled = true
//        }
        
    }
    
}
