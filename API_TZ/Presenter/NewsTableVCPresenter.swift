//
//  NewsTableVCPresenetr.swift
//  API_TZ
//
//  Created by Виталий Охрименко on 21/05/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit

class NewsTableVCPresenter {
    
    weak private var view: TableVCView?
    private let dataService: DataService!
    
    private let url = "https://newsapi.org/"
    private let apiKey = "60b26ec8f5c44a6d8eadb5b23b2e7e9d"
    private var pageSize = 10
    private var page = 1
    
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    func generateUrl(page: Int) -> String {
        let urlFor = "\(url)v2/top-headlines?country=us&pageSize=\(pageSize)&page=\(page)&sortBy=publishedAt&apiKey=\(apiKey)"
        return urlFor
    }
    
    func attachView(_ viewProtocol: TableVCView) {
        self.view = viewProtocol
    }
    
    func fetchData() {
        DispatchQueue.main.async {
            self.view?.startActivityIndicator()
        }
        dataService.fetchNewsData(url: generateUrl(page: page)) { [weak self] news in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view?.setArticles(articles: news)
                self.view?.stopActivityIndicator()
            }
        }
    }
    func loadTable() {
        self.page += 1
        
        dataService.fetchNewsData(url: generateUrl(page: page)) { [weak self] news in
            
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view?.setArticles(articles: news)
            }
        }
    }
    
    
    
}
