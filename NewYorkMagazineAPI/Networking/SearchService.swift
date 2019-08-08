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
    typealias ArticleResult = ([Article]) -> ()
    var news: [News] = []
    
    var articles = [Article]()
    

    

    
    fileprivate func updateResult(_ error: Error?, _ data: Data?, _ response: URLResponse?) {
        news.removeAll()
        
        let errorMessage = ""
        if error != nil {
            print(errorMessage + "\(String(describing: error?.localizedDescription))")
        } else if let data = data {
            print("-----------------scope came here------------------")
            if  let myData = try? JSONDecoder().decode(News.self, from: data) {
            news.append(myData)
                print(myData, "news are here or not")
            }
//                print("\(String(describing: String(data: data, encoding: .utf8)))")
        }
    }
    
    

    
    
    
    
    //MARK: - Search -
    func networkingWithURL(urlString: String,
                           searchTerm: String,
                           sorts: Sorts,
                           completion: @escaping NewsResult) {
        
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
            print("=-=-the ultimate url requested by search =-=-=",url)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
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
                        country: String? = nil,
                        completion: @escaping NewsResult) {
        
        if var urlComponents = URLComponents(string: urlString) {
            
            var queryPool = [String: String]()
            
            if country != nil {
                queryPool.updateValue(country!, forKey: "country")
            } else {
                queryPool = [ "sources": sources.rawValue
                ]
            }

            
            var searchConditions = [URLQueryItem]()
            
            for (key, value) in queryPool {
                let queriedItem = URLQueryItem(name: key, value: value)
                searchConditions.append(queriedItem)
            }
            
            urlComponents.queryItems = searchConditions
            urlComponents.queryItems?.append(URLQueryItem(name: "apiKey",
                                                          value: "648dde22d5134d1b95541132698f961d"))
            guard let url = urlComponents.url else { return }
            print("=-=-the ultimate url requested =-=-=",url)
            var request = URLRequest(url: url)
            request.addValue("648dde22d5134d1b95541132698f961d", forHTTPHeaderField: "X-Api-Key")
            request.httpMethod = "GET"
            
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


