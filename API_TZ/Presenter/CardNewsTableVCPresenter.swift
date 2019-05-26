//
//  CardNewsTableVCPresenter.swift
//  API_TZ
//
//  Created by Виталий Охрименко on 21/05/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//
import UIKit

class CardNewsTableVCPresenter {
    
    weak private var cardNewsView: CardNewsView?
    private let dataService: DataService!
    
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    func attachView(_ viewProtocol: CardNewsView) {
        self.cardNewsView = viewProtocol
    }
    
    func getImageOfNewsCell(url: String) {
        dataService.downloadImage(url: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.cardNewsView?.setImages(image: image)
            }
        }
    }
}
