//
//  Service.swift
//  API_TZ
//
//  Created by Виталий Охрименко on 21/05/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit

class DataService {
    
    static let service = DataService()
    
    func downloadImage(url: String, completion: @escaping (_ image: UIImage)->()) {
        
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error)  in
            guard let data = data else { return }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            } .resume()
    }
    
    func fetchNewsData(url: String, completion: @escaping (_ articles: [Article])->()) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let news = try decoder.decode(News.self, from: data)
                completion(news.articles)
            } catch let error {
                print("parsing error: \(error)")
            }
            }.resume()
        
    }
}

