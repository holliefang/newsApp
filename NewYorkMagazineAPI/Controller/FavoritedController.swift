//
//  FavoritedController.swift
//  NewYorkMagazineAPI
//
//  Created by Sihan Fang on 2019/5/9.
//  Copyright © 2019 Sihan Fang. All rights reserved.
//

import UIKit

class FavoritedController: UITableViewController {
    
    var savedNewsModel = SavedNewsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Favorites"
//        savedNewsModel.getArticle()
        savedNewsModel.savedArticles.bind { art in
            print("reload")
            print("\(self.savedNewsModel.savedArticles.value.count), the saved news from favorites controller")
            self.tableView.reloadData()
        }
//        setupNotificationCenter()
        
//        if let articles = UserDefaults.standard.value(forKey: "newsData") as? [Data] {
//            for articleData in articles {
//                newsData.append(articleData)
//                guard let article = try? JSONDecoder().decode(Article.self, from: articleData) else {return}
//                savedArticles.append(article)
//            }
////            self.tableView.reloadData()
//        } else {
//            print("nooooooo")
//        }
    }
    
//    func setupNotificationCenter() {
//        NotificationCenter.default.addObserver(forName: .newsRadio, object: nil, queue: .main) {[unowned self] (notification) in
//            let webVC = notification.object as! WebViewController
//            if let news = webVC.currentNews {
//                self.savedArticles.append(news)
//                self.tableView.reloadData()
//
//                let userDefault = UserDefaults.standard
//                guard let articleData = try? JSONEncoder().encode(news) else {return}
//                self.newsData.append(articleData)
//
//                userDefault.set(self.newsData, forKey: "newsData")
//            }
//        }
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedNewsModel.filteredArticles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: HeadlinesViewCell.cellID, for: indexPath) as? HeadlinesViewCell {
            
//            savedNewsModel.index = indexPath.row
//            cell.configure(dataSource: savedNewsModel)
            let article = savedNewsModel.filteredArticles[indexPath.row]
            cell.dateLabel.text = News.fetchDate(publishTime: article.publishedAt)
            cell.titleLabel.text = article.title
            return cell
        }
        

        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard savedNewsModel.savedArticles.value.count > 0 else {return}
        News.showNewsToWebViewCtrller(savedNewsModel.savedArticles.value[indexPath.row], navigationController)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard savedNewsModel.savedArticles.value.count > 0 else {return}
//            savedArticles.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            tableView.beginUpdates()
//            tableView.endUpdates()
        }
    
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

  
}
