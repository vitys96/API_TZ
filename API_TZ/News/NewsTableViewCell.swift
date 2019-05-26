//
//  NewsTableViewCell.swift
//  API_TZ
//
//  Created by Виталий Охрименко on 23/04/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    var article: Article? {
        didSet {
            if let title = article?.title, let mainText = article?.content {
                self.titleLabel.text = title
                self.mainText.text = mainText
            }
            else {
                titleLabel.text = "Не удалось загрузить данные"
                self.mainText.isHidden = true
            }
            
            guard let dateOfNews = article?.publishedAt else { return }
            dateLabel.text = decodeDate(dateString: dateOfNews)
            
            guard let imageUrl = article?.urlToImage else { return }
            imageArticle.dowloadFromServer(link: imageUrl)
        }
        
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageArticle: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setup()
        
    }
    
    private func setup() {
        backView.layer.cornerRadius = 10
    }
    
//    private func updateUI() {
//        guard let imageUrlArticle = article?.urlToImage else { return }
//        NetworkManager.downloadImage(url: imageUrlArticle) { [weak self] (image) in
//            guard let strongSelf = self else { return }
//            strongSelf.imageArticle.image = image
//        }
//    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
