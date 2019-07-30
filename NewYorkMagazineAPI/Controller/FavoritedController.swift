//
//  FavoritedController.swift
//  NewYorkMagazineAPI
//
//  Created by Sihan Fang on 2019/5/9.
//  Copyright © 2019 Sihan Fang. All rights reserved.
//

import UIKit

class FavoritedController: UITableViewController {
    
    var savedNews = [News.Article]() {
        didSet{
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        navigationItem.title = "Favorites"
        setupNotificationCenter()
        
        

    }
    
    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(forName: .newsRadio, object: nil, queue: .main) { (notification) in
            let webVC = notification.object as! WebViewController
            if let news = webVC.currentNews {
                self.savedNews.append(news)
                self.tableView.reloadData()

            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedNews.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = savedNews[indexPath.row].title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard savedNews.count > 0 else {return}
        News.showNewsToWebViewCtrller(savedNews[indexPath.row], navigationController)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard savedNews.count > 0 else {return}
            savedNews.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    

  
}
