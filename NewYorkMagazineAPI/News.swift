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
    var articles = [Article]()
    

    
    static func fetchImage(urlToImage: String) -> UIImage {
        let url = URL(string: urlToImage)
        if let data = try? Data(contentsOf: url!) {
            if let image = UIImage(data: data) {
                return image
            }
        }
        return UIImage()
        
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
    
    static func showNewsToWebViewCtrller(_ news: Article, _ navigationController: UINavigationController?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webVC = storyboard.instantiateViewController(withIdentifier: "WebVC") as! WebViewController

        webVC.currentNews = news
        webVC.url = URL(string: news.url)
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    

}

struct Article: Codable, Equatable {
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.title == rhs.title
    }
    
    
    var source: Source
    
    var author: String? = nil
    var title: String
    var description: String
    var url: String
    var urlToImage: String?
    var publishedAt: String
    var content: String
    
}

struct Source: Codable {
    var id: String? = nil
    var name: String
}

enum Sorts: String, CodingKey {
    case popularity
    case relevancy
    case publishedAt
}

enum Sources: String, CodingKey {
    case bbcNews = "bbc-news"
    case newYorkMegazine = "new-york-magazine"
    case dailyMail = "daily-mail"
    case mtvNews = "mtv-news"
    case cbsNews = "cbs-news"
    case googleNews = "google-news"
    case focus = "focus"
    case t3n = "t3n"
    case theVerge = "the-verge"
    case time = "time"
    case wired = "wired"
    case theGlobe = "the-globe-and-mail"
    case techCrunch = "techcrunch"
    case metro = "metro"
    case mirror = "mirror"
    case newScientist = "new-scientist"
    case polygon = "polygon"
    case theIrishTimes = "the-irish-times"
    case redditAll = "reddit-r-all"
    


}
