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
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    var currentNews: News.Article?
    var savedNews: [News.Article]?
    
    var url = URL(string: "https://www.instapaper.com/u")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlRequest = URLRequest(url: url!)
        
        collectionView.dataSource = self
        navigationItem.title = "News"
        webView.navigationDelegate = self
        webView.load(urlRequest)
        setupNavButtons()
    }
    
    func setupNavButtons() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleShare))
        
        navigationItem.rightBarButtonItems = [saveButton, shareButton]
    }
    @objc func handleShare() {
        guard let newsURL = currentNews?.url else {return}
        let shareNews = "Check out this news: \(newsURL)"
        let activityController = UIActivityViewController(activityItems: [shareNews], applicationActivities: nil)
        self.present(activityController, animated: true)
    
    }
    @objc func handleSave() {
        NotificationCenter.default.post(name: .newsRadio, object: self)
        let alert = UIAlertController(title: "Saved", message: "News Saved Successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
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

extension WebViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .green
        return cell
    }
    
    
}


