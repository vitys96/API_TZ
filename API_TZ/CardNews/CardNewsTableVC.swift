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
    fileprivate let presenter = CardNewsTableVCPresenter(dataService: DataService())
    var detailCellArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.attachView(self)
        self.setupUI()
        self.dataVC()
    }
    
    private func dataVC() {
        [article.title, article.urlToImage, article.content].forEach { eachs in
            guard let each = eachs else { return }
            self.detailCellArray.append(each)
        }
    }
    
    private func setupUI() {
        guard let imageUrlArticle = article?.urlToImage else { return }
        self.presenter.getImageOfNewsCell(url: imageUrlArticle)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.rowHeight = UITableView.automaticDimension
    }
}

extension CardNewsTableVC: CardNewsView {
    
    func setImages(image: UIImage) {
        self.newsImageView.image = image
        self.reloadData()
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
}


extension CardNewsTableVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CardNewsTableViewCell else
        { return UITableViewCell(style: .default, reuseIdentifier: "cell")}
        
//        configureCell(cell: cell, for: indexPath)
        if article.content != nil {
            cell.mainText = article.content
            cell.titleText = article.title
        } else {
            cell.mainText = ""
            cell.titleText = ""
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 2000
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
