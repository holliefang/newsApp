//
//  SavedNewsViewModel.swift
//  NewYorkMagazineAPI
//
//  Created by Hollie Fang on 2019/10/3.
//  Copyright © 2019 Sihan Fang. All rights reserved.
//

import UIKit

class SavedNewsViewModel {
    var savedArticles: Box<[Article]> = Box([])
    var filteredArticles: [Article] {
        return savedArticles.value.removingDuplicates()
    }
    private var newsData = [Data]()
    var index = 0
    
    func getArticle() {
        if let articles = UserDefaults.standard.value(forKey: "newsData") as? [Data] {
            print(articles, "hello ")
            for articleData in articles {
                newsData.append(articleData)
                guard let article = try? JSONDecoder().decode(Article.self, from: articleData) else {return}
                savedArticles.value.append(article)
            }
            
        } else {
            print("nooooooo")
        }
    }
    
    func saveArticle(_ article: Article?) {
        guard let art = article else {return}
        savedArticles.value.append(art)
        guard let articleData = try? JSONEncoder().encode(art) else {return}
        self.newsData.append(articleData)
        UserDefaults.standard.set(self.newsData, forKey: "newsData")
        
    }
    
    init() {
        getArticle()
//        UserDefaults.standard.set(nil, forKey: "newsData")
    }
    }

extension SavedNewsViewModel: NewsDataSource {
    var title: String {
        return savedArticles.value[index].title
    }
    
    var date: String {
        let publishTime = savedArticles.value[index].publishedAt
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
        return ""
    }
    
    var image: UIImage {
        return UIImage()
    }
    
    func onNewsTapped(navigationController: UINavigationController?) {
        
    }
    
    
    
}
    

extension Array where Element: Equatable {
    func removingDuplicates() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}
