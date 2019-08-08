//
//  FavoritedController.swift
//  NewYorkMagazineAPI
//
//  Created by Sihan Fang on 2019/5/9.
//  Copyright © 2019 Sihan Fang. All rights reserved.
//

import UIKit

class FavoritedController: UITableViewController {
    
    var savedArticles = [Article]()
//    {
//        didSet{
//            self.tableView.reloadData()
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Favorites"
        setupNotificationCenter()
        
        

    }
    
    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(forName: .newsRadio, object: nil, queue: .main) {[unowned self] (notification) in
            let webVC = notification.object as! WebViewController
            if let news = webVC.currentNews {
                self.savedArticles.append(news)
                self.tableView.reloadData()

            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedArticles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: HeadlinesViewCell.cellID, for: indexPath) as? HeadlinesViewCell {
            
            let article = savedArticles[indexPath.row]
            cell.dateLabel.text = News.fetchDate(publishTime: article.publishedAt)
//            cell.newsImageView.image = News.fetchImage(urlToImage: article.urlToImage!)
            cell.titleLabel.text = article.title
        }
        

        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard savedArticles.count > 0 else {return}
        News.showNewsToWebViewCtrller(savedArticles[indexPath.row], navigationController)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard savedArticles.count > 0 else {return}
            savedArticles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
//            tableView.beginUpdates()
//            tableView.endUpdates()
        }
    
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

  
}
