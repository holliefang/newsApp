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
    
    let newsModel = NewsViewModel()
    
//    let searchService = SearchService()
    
//    var news = [Article]() {
//        didSet {
//            DispatchQueue.main.async {
////                self.tableView.reloadData()
//                self.collectionView.reloadData()
//            }
//        }
//    }
//    
//    var otherNews = [Article]() {
//        didSet {
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
////                self.collectionView.reloadData()
//            }
//        }
//
//    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = "Today's Headlines"
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backItem?.title = ""
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        collectionView.dataSource = self
        collectionView.delegate = self
        
        newsModel.news.bind { (article) in
//            self.newsModel.news.value = article
            self.collectionView.reloadData()
        }
        newsModel.otherNews.bind { (article) in
            self.tableView.reloadData()
            DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
                
            }

        }
        
        
            
//        getNews(from: .theIrishTimes) { [unowned self] (articles) in
//            self.news = articles
//        }
//
//        getNews(from: .newYorkMegazine) { [unowned self] (articles) in
//            self.otherNews = articles
//        }
    }
    
//    private func getNews(from sources: Sources, completion:@escaping ([Article])-> ()) {
//
//        searchService.requestWithURL(urlString: "https://newsapi.org/v2/top-headlines",
//                                     sources: sources) { (news) in
//                                        if let articles = news.first?.articles {
//                                        completion(articles)
//                                        }
//                                        DispatchQueue.main.async {
//                                            self.activityIndicator.stopAnimating()
//                                            self.activityIndicator.isHidden = true }
//        }
//
//    }
    
    
    
}

extension HeadlinesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModel.otherNews.value.count
        
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    //Leave least space on the bottom of the TBV
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.frame.width,
                                              height: 40))
        headerView.backgroundColor = .white
        
        let label = UILabel(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.frame.width,
                                          height: 40))
        let attrubutedText = NSAttributedString(string: "Topics",
                                                attributes: [NSAttributedString.Key.font: UIFont(name: "Hoefler Text", size: 20)!,
                                                             NSAttributedString.Key.foregroundColor: UIColor.black
            ])

        label.attributedText = attrubutedText
        label.textAlignment = .center
        headerView.addSubview(label)
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: HeadlinesViewCell.cellID, for: indexPath) as? HeadlinesViewCell {
            
            newsModel.index = indexPath.row
            cell.configure(dataSource: newsModel)
            
            
//            let result = newsModel.otherNews.value[indexPath.row]
//            let dateString = News.fetchDate(publishTime: result.publishedAt)
//            cell.titleLabel.text = result.title
//            cell.dateLabel.text = dateString
//            cell.newsImageView.image = News.fetchImage(urlToImage: result.urlToImage!)

            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height * 0.3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newsModel.index = indexPath.row
        newsModel.onNewsTapped(navigationController: navigationController)
//        let result =  newsModel.otherNews.value[indexPath.row]
//        News.showNewsToWebViewCtrller(result, navigationController)
    }


}

// MARK: - CollectionView -
extension HeadlinesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return newsModel.news.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopHeadlinesCollectionViewCell.cellID, for: indexPath) as! TopHeadlinesCollectionViewCell
        newsModel.index = indexPath.row
        
        cell.configure(dataSource: newsModel)
        
//        let result = newsModel.news.value[indexPath.row]
//
//        if let imageURL = result.urlToImage {
//                let image = News.fetchImage(urlToImage: imageURL)
//                cell.set(result.title, image)
//            }
//        let dateString = News.fetchDate(publishTime: result.publishedAt)
//        cell.dateLabel.text = dateString
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let result = newsModel.news.value[indexPath.row]
        News.showNewsToWebViewCtrller(result, navigationController)
        
    }
}



