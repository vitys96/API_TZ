//
//  NetworkManager.swift
//  API_TZ
//
//  Created by Виталий Охрименко on 23/04/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import Foundation
import UIKit


class NetworkManager {
    

    static func downloadImage(url: String, completion: @escaping (_ image: UIImage)->()) {
        
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error)  in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            } .resume()
    }
    
    
    static func fetchNewsData(url: String, completion: @escaping (_ articles: [Article])->()) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let courses = try decoder.decode(News.self, from: data)
                completion(courses.articles)
            } catch let error {
                print("Error serialization json", error)
            }
            
            }.resume()
    }
}

