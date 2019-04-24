//
//  NewsViewModel.swift
//  API_TZ
//
//  Created by Виталий Охрименко on 23/04/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import Foundation
import UIKit

struct NewsViewModel {
    
    var articles: [Article]
    
    init(news: News) {
        self.articles = news.articles
    }
    
}
