//
//  SearchBarViewController.swift
//  NewYorkMagazineAPI
//
//  Created by Sihan Fang on 2019/1/24.
//  Copyright © 2019 Sihan Fang. All rights reserved.
//

import UIKit

class SearchBarViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let searchService = SearchService()
    
    var resultsNews = [Article]() {
        didSet {
            print(resultsNews.count, "number of news")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var savedNews = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.definesPresentationContext = true
       tableView.dataSource = self
       tableView.delegate = self
       activityIndicator.isHidden = true
        
        navigationItem.title = "Search"
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search News..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchBar.delegate = self
    }
    
}

extension SearchBarViewController: UISearchBarDelegate {

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }

        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false

        }
        searchService.networkingWithURL(urlString: "https://newsapi.org/v2/everything",
                                        searchTerm: searchText,
                                        sorts: .popularity)
        { (news) in
            guard let articles = news.first?.articles else {return}
            self.resultsNews = articles
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }
}

 //MARK: TBV DataSource

extension SearchBarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultsNews.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchResultTableViewCell
    
        if resultsNews.count < 0 {
            cell.titleLabel.text = "Search some news..."
                        cell.authorLabel.isHidden = true
                        cell.timeLabel.isHidden = true
                        return cell            
        }

        guard resultsNews.count > 0 else {return UITableViewCell()}
        
        let result = resultsNews[indexPath.row]
        
        if let imageUrl = result.urlToImage, let author = result.author {
            let image = News.fetchImage(urlToImage: imageUrl)
            let dateString = News.fetchDate(publishTime: result.publishedAt)
            cell.authorLabel.isHidden = false
            cell.timeLabel.isHidden = false
            
            
            cell.set(title: result.title, author: author, date: dateString, image: image)
            
        }
        return cell
    }
}

extension SearchBarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard resultsNews.count > 0 else {return}
        
        let result = resultsNews[indexPath.row]
        News.showNewsToWebViewCtrller(result, navigationController)
        

    }
    }




