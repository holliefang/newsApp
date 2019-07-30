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
    
    var resultsNews = [News]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var savedNews = [News]()
    
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
            self.resultsNews = news
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
        
        return resultsNews.first?.articles.count ?? 1
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchResultTableViewCell
    
        guard resultsNews.first?.articles != nil else {
            cell.titleLabel.text = "Search some news..."
            cell.authorLabel.isHidden = true
            cell.timeLabel.isHidden = true
//            cell.imageView?.image = UIImage(named: "news@2x")
            return cell
        }
       
        if let result = resultsNews.first?.articles[indexPath.row] {

            if let imageUrl = result.urlToImage {
            let image = News.fetchImage(urlToImage: imageUrl)
            let dateString = News.fetchDate(publishTime: result.publishedAt)
            cell.authorLabel.isHidden = false
            cell.timeLabel.isHidden = false
            

            cell.set(title: result.title, author: result.author, date: dateString, image: image)
            
            }
        }
        return cell
    }
}

extension SearchBarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard resultsNews.first?.articles.count != nil else {return}
        
        if let result = resultsNews.first?.articles[indexPath.row] {
        News.showNewsToWebViewCtrller(result, navigationController)
        }

    }
    

    
    }


