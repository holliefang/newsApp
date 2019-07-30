//
//  ViewController.swift
//  NewYorkMagazineAPI
//
//  Created by Sihan Fang on 2019/1/22.
//  Copyright © 2019 Sihan Fang. All rights reserved.
//

import UIKit

class HeadlinesViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let searchService = SearchService()
    
    var news = [News]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.collectionView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        collectionView.dataSource = self
        collectionView.delegate = self
        
        navigationItem.title = "Today's Headlines"
    
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
        }

        searchService.requestWithURL(urlString: "https://newsapi.org/v2/top-headlines",
                                     sources: .newYorkMegazine) { (news) in
                                     self.news = news
                                        DispatchQueue.main.async {
                                            self.activityIndicator.stopAnimating()
                                            self.activityIndicator.isHidden = true }
        }
    }
}

extension HeadlinesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return news.first?.articles.count ?? 1 
        
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return .leastNormalMagnitude
//    }
    
    //Leave least space on the bottom of the TBV
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Today"
        }
        return "Headlines from NYT"
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let result = news.first?.articles[indexPath.row] {
            let dateString = News.fetchDate(publishTime: result.publishedAt)
            cell.textLabel?.text = result.title
            cell.detailTextLabel?.text = dateString
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let result = news.first?.articles[indexPath.row] else {return}
        News.showNewsToWebViewCtrller(result, navigationController)
    }


}

// MARK: - CollectionView -
extension HeadlinesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 16, height: collectionView.frame.height - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return news.first?.articles.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! TopHeadlinesCollectionViewCell
        if let result = news.first?.articles[indexPath.row] {
            
            if let imageURL = result.urlToImage {
                let image = News.fetchImage(urlToImage: imageURL)
                cell.set(result.title, image)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let result = news.first?.articles[indexPath.row] else {return}
        News.showNewsToWebViewCtrller(result, navigationController)
        
    }
}




