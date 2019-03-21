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
        collectionView.dataSource = self
        collectionView.delegate = self
    
        
        
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
//        if let num = news.first?.articles.count {
//            return num
//        }
        
        
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "hey"
        cell.detailTextLabel?.text = "shit"
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "WebVC") as! WebViewController
//        vc.url = URL(string: news[0].articles[indexPath.row].url)
//
//        navigationController?.pushViewController(vc, animated: true)
//
//    }

}


extension HeadlinesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

//        if let num = news.first?.articles.count {
//        return num
//
//        } else {
//            return 1
//        }
        return news.first?.articles.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! TopHeadlinesCollectionViewCell
        
//        let title = news.first?.articles[indexPath.row].title
        if let urlImage = news.first?.articles[indexPath.row].urlToImage {
            
            let image = News.fetchImage(urlToImage: urlImage)
            cell.topHeadlinesImageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("click")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebVC") as! WebViewController
        vc.url = URL(string: news[0].articles[indexPath.row].url)

        navigationController?.pushViewController(vc, animated: true)
        
    }
}
//
//extension HeadlinesViewController: UICollectionViewDelegateFlowLayout {
//    
//
//    
//}




