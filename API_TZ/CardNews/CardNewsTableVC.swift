//
//  CardNewsTableVC.swift
//  API_TZ
//
//  Created by Виталий Охрименко on 23/04/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit

class CardNewsTableVC: UITableViewController {
    @IBOutlet weak var newsImageView: UIImageView!
    
    var article: Article!
    
    var detailCellArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataVC()
        configScreen()
    }
    
    private func dataVC() {
        [article.title, article.urlToImage, article.content].forEach { (eachs) in
            guard let each = eachs else { return }
            detailCellArray.append(each)
        }
    }
    
    private func configScreen() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.rowHeight = UITableView.automaticDimension
        guard let imageUrlArticle = article?.urlToImage else { return }
        NetworkManager.downloadImage(url: imageUrlArticle) { [weak self] (image) in
            guard let strongSelf = self else { return }
            strongSelf.newsImageView.image = image
        }
    }
    
    private func configureCell(cell: CardNewsTableViewCell, for indexParth: IndexPath) {
        cell.titleText = article.title
        cell.mainText = article.content
    }
    
    
}

extension CardNewsTableVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CardNewsTableViewCell else { return UITableViewCell(style: .default, reuseIdentifier: "cell")}
        
        configureCell(cell: cell, for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 2000
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
