//
//  NewsTableVCView.swift
//  API_TZ
//
//  Created by Виталий Охрименко on 21/05/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import Foundation

protocol TableVCView: NSObjectProtocol {
    func setArticles(articles: [Article])
    func startActivityIndicator()
    func stopActivityIndicator()
    func reloadData()
    
}
