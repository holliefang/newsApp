//
//  NewsViewModel.swift
//  NewYorkMagazineAPI
//
//  Created by Hollie Fang on 2019/10/2.
//  Copyright © 2019 Sihan Fang. All rights reserved.
//

import UIKit

class NewsViewModel {
    
    var news: Box<[Article]> = Box([])
    var otherNews: Box<[Article]> = Box([])
    let searchService = SearchService()
    var index: Int = 0
    
    
    init() {
        getNews(from: .newYorkMegazine) { (articles) in
            self.news.value = articles
        }
        getNews(from: .newYorkMegazine) { (articles) in
            self.otherNews.value = articles
        }
    }
    
    
    func getNews(from sources: Sources, completion:@escaping ([Article])-> ()) {
        
        searchService.requestWithURL(urlString: "https://newsapi.org/v2/top-headlines",
                                     sources: sources) { (news) in
                                        if let articles = news.first?.articles {
                                            completion(articles)
                                        }
        }
        
    }
    
}

extension NewsViewModel: NewsDataSource {
    func onNewsTapped(navigationController: UINavigationController?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webVC = storyboard.instantiateViewController(withIdentifier: "WebVC") as! WebViewController
        
        webVC.currentNews = news.value[index]
        webVC.url = URL(string: news.value[index].url)
        navigationController?.pushViewController(webVC, animated: true)

    }
    
    var title: String {
        return news.value[index].title
    }
    
    var date: String {
        let publishTime = news.value[index].publishedAt
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
    
    var author: String {
        return  news.value[index].author!
    }
    
    var image: UIImage {
        if let url = news.value[index].urlToImage {
            let url = URL(string: url)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            return image!
        }
        return UIImage()
    }
    
    
}
