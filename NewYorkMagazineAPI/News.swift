//
//  NewsModel.swift
//  NewYorkMagazineAPI
//
//  Created by Sihan Fang on 2019/1/22.
//  Copyright © 2019 Sihan Fang. All rights reserved.
//

import Foundation
import UIKit

struct News: Decodable {
    
    var status: String
    var totalResults: Int
    var articles: [Article]
    
    struct Article: Decodable {
        
        var source: Megazine
        
        var author: String
        var title: String
        var description: String
        var url: String
        var urlToImage: String?
        var publishedAt: String
        var content: String
        
        struct Megazine: Decodable {
            var id: String? = "new-york-magazine"
            var name: String = "New York Magazine"
        }
    }
    
    static func fetchImage(urlToImage: String) -> UIImage {
        let url = URL(string: urlToImage)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        
        return image!
        
    }
    
    static func fetchDate(publishTime: String) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        let formatterISO8601 = ISO8601DateFormatter()
        if let date = formatterISO8601.date(from: publishTime){
            let dateString = formatter.string(from: date)
            return dateString
        }
        
        return ""

    }
    
    static func showNewsToWebViewCtrller(_ news: News.Article, _ navigationController: UINavigationController?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webVC = storyboard.instantiateViewController(withIdentifier: "WebVC") as! WebViewController
        webVC.currentNews = news
        webVC.url = URL(string: news.url)
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    

}
