//
//  NewsTableVC.swift
//  API_TZ
//
//  Created by Виталий Охрименко on 23/04/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit

class NewsTableVC: UITableViewController {
    
    let url = "https://newsapi.org/"
    let apiKey = "241f88416a024aa4ba2b2472c6693cc4"
    var pageSize = 10
    var page = 1
    
    var articles = [Article]()
    
    lazy var refresh: UIRefreshControl = {
        let refreshConroll = UIRefreshControl()
        refreshConroll.tintColor = .gray
        refreshConroll.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        return refreshConroll
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchData()
        
    }
    private func generateUrl(page: Int) -> String {
        let urlFor = "\(url)v2/top-headlines?country=us&category=business&pageSize=10&\(page)sortBy=publishedAt&apiKey=\(apiKey)"
        return urlFor
    }
    
    private func fetchData() {
        NetworkManager.fetchNewsData(url: generateUrl(page: page)) { [weak self] (articles) in
            guard let strongSelf = self else { return }
            strongSelf.articles = articles
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
                strongSelf.refresh.endRefreshing()
            }
        }
    }
    
    @objc private func refreshData() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.fetchData()
        })
    }
    
    private func configureCell(cell: NewsTableViewCell, for indexPath: IndexPath) {
        let oneArticle = articles[indexPath.row]
        cell.article = oneArticle
    }
    
    
    private func setupTableView() {
        tableView.allowsSelection = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refresh
    }
    
    @objc private func loadTable() {
        page += 1
        NetworkManager.fetchNewsData(url: generateUrl(page: page)) { [weak self] (art) in
             guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                let beforeCount = strongSelf.articles.count
                strongSelf.articles.append(contentsOf: art)
                let insertIndexes = (beforeCount..<strongSelf.articles.count).map { IndexPath(row: $0, section: 0) }
                strongSelf.tableView.beginUpdates()
                strongSelf.tableView.insertRows(at: insertIndexes, with: .left)
                strongSelf.tableView.endUpdates()
            }
        }
    }
}

extension NewsTableVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? NewsTableViewCell else { return UITableViewCell(style: .default, reuseIdentifier: "cell")}
        
        configureCell(cell: cell, for: indexPath)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newsCard = segue.destination as? CardNewsTableVC
        
        guard let index = tableView.indexPathForSelectedRow?.row else { return }
        newsCard?.article = articles[index]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "show", sender: self)
        //        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //        guard let vc = storyBoard.instantiateViewController(withIdentifier: "CardNewsTableVC") as? CardNewsTableVC else { return }
        //
        //        vc.article = self.articles[indexPath.row]
        //
        //        vc.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == articles.count - 1 {
            if articles.count < 100 {
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
                cell.layer.transform = transform
                
                UIView.animate(withDuration: 1.0) {
                    cell.alpha = 1.0
                    cell.layer.transform = CATransform3DIdentity
                    self.perform(#selector(self.loadTable), with: nil, afterDelay: 1.0)
                }
                
            }
        }
    }
}

//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//
//        if offsetY > contentHeight - scrollView.frame.height {
//            if !fetchingMore {
//                beginFetch()
//            }
//        }
//    }
//
//    private func beginFetch() {
//        fetchingMore = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.pageSize += 10
//            NetworkManager.fetchNewsData(url: self.generateUrl(pageSize: 20), completion: { (articles) in
//                self.articles.append(contentsOf: articles)
//                self.fetchingMore = false
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            })
//
//        }
//    }
