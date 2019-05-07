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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.definesPresentationContext = true
       tableView.dataSource = self
       tableView.delegate = self
       activityIndicator.isHidden = true
        
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
            print("the result is: \(self.resultsNews.first?.articles.count as Optional)")

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
        
        if let num = resultsNews.first?.articles.count {
            return num
        }
        return 1
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchResultTableViewCell
       
        cell.titleLabel.text = resultsNews.first?.articles[indexPath.row].title
        cell.authorLabel.text = resultsNews.first?.articles[indexPath.row].author
        cell.timeLabel.text = resultsNews.first?.articles[indexPath.row].publishedAt
        print("dsadadasd\(resultsNews.first?.articles[0].content)")
                
        if let input = resultsNews.first?.articles[indexPath.row].publishedAt {
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            
            let formatterISO8601 = ISO8601DateFormatter()
            let date = formatterISO8601.date(from: input)
            
            let dateString = formatter.string(from: date!)
            
            cell.timeLabel.text = dateString

        }
        
        if let urlImage = resultsNews.first?.articles[indexPath.row].urlToImage {
            let image = News.fetchImage(urlToImage: urlImage)
            cell.searchImage.image = image
        }
        
        return cell
    }
}

extension SearchBarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebVC") as! WebViewController
        if let url = URL(string: (resultsNews.first?.articles[indexPath.row].url)!) {
            vc.url = url
        }
        navigationController?.show(vc, sender: self)
    }
    
    }

