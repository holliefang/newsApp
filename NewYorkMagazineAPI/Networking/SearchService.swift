//
//  SearchService.swift
//  NewYorkMagazineAPI
//
//  Created by Sihan Fang on 2019/1/31.
//  Copyright © 2019 Sihan Fang. All rights reserved.
//

import Foundation

//https://newsapi.org/v2/everything?q=apple&sortBy=popularity&apiKey=648dde22d5134d1b95541132698f961d


class SearchService {
    
    typealias NewsResult = ([News]) -> ()
    var news: [News] = []
    
    enum Sorts: String, CodingKey {
        case popularity
        case relevancy
        case publishedAt
    }
    
    enum Sources: String, CodingKey {
        case bbcNews = "bbc-news"
        case newYorkMegazine = "new-york-magazine"
    }
    

    
    fileprivate func updateResult(_ error: Error?, _ data: Data?, _ response: URLResponse?) {
        news.removeAll()
        
        let errorMessage = ""
        if error != nil {
            print(errorMessage + "\(String(describing: error?.localizedDescription))")
        } else if let data = data {
            if  let myData = try? JSONDecoder().decode(News.self, from: data) {
            news.append(myData)
            } else {
                print("\(String(describing: String(data: data, encoding: .utf8)))")
            }
            
        }
    }
    //MARK: - Search -
    func networkingWithURL(urlString: String, searchTerm: String, sorts: Sorts, completion: @escaping NewsResult) {
        
        if var urlComponents = URLComponents(string: urlString) {
            
            let queryPool = ["q":searchTerm,
                             "sortBy": sorts.rawValue,
            ]
            var searchConditions = [URLQueryItem]()
            
            for (key, value) in queryPool {
                let queriedItem = URLQueryItem(name: key, value: value)
                searchConditions.append(queriedItem)
            }
            
            urlComponents.queryItems = searchConditions
            
            guard let url = urlComponents.url else { return }
            
            var request = URLRequest(url: url)
            request.addValue("648dde22d5134d1b95541132698f961d", forHTTPHeaderField: "X-Api-Key")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
            
                do{
                    self.updateResult(error, data, response)
                }
                
                DispatchQueue.main.async {
                    completion(self.news)
                }

                
            }.resume()
            
            
        }
        
    }
    
    //MARK: - Non-Search -
    func requestWithURL(urlString: String,
                        sorts: Sorts? = nil,
                        sources: Sources,
                        searchTerm: String? = nil,
                        completion: @escaping NewsResult) {
        
        if var urlComponents = URLComponents(string: urlString) {
            
            let queryPool = [
                             "sources": sources.rawValue
                             ]
            var searchConditions = [URLQueryItem]()
            
            for (key, value) in queryPool {
                let queriedItem = URLQueryItem(name: key, value: value)
                searchConditions.append(queriedItem)
            }
            
            urlComponents.queryItems = searchConditions
            
            guard let url = urlComponents.url else { return }
            print(url)
            var request = URLRequest(url: url)
            request.setValue("648dde22d5134d1b95541132698f961d", forHTTPHeaderField: "X-Api-Key")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                do{
                    self.updateResult(error, data, response)
                }
                
                DispatchQueue.main.async {
                    completion(self.news)
                }
                
                
                }.resume()
            
            
        }
        
    }
    
}


