//
//  NewsTableVC.swift
//  API_TZ
//
//  Created by Виталий Охрименко on 23/04/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//
import UIKit

class NewsTableVC: UITableViewController {
    
    private var articles = [Article]()
    private var presenter = NewsTableVCPresenter(dataService: DataService())
    let activityInd = UIActivityIndicatorView(style: .gray)
    
    lazy var refresh: UIRefreshControl = {
        let refreshConroll = UIRefreshControl()
        refreshConroll.tintColor = .gray
        refreshConroll.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshConroll
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.attachView(self)
        self.setupTableView()
        self.chechInternet()
    }
    
    
    private func chechInternet() {
        if Reachability.isConnectedToNetwork() {
            self.presenter.fetchData()
        } else {
            self.alert()
        }
    }
    private func alert() {
            let alert = UIAlertController(title: "Отсутствует подключение к сети", message: "Проверьте настройки сети", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { _ in
                self.chechInternet()
            }))
            self.present(alert, animated: true, completion: nil)
    }

    @objc private func refreshData() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            guard let self = self else { return }
            self.chechInternet()
            
        })
        
    }
    
    private func configureCell(cell: NewsTableViewCell, for indexPath: IndexPath) {
        let oneArticle = articles[indexPath.row]
        cell.article = oneArticle
    }
    
    
    private func setupTableView() {
        activityInd.center = view.center
        self.view.addSubview(activityInd)
        tableView.allowsSelection = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refresh
    }
    
    @objc private func loadTable() {

        DataService.service.fetchNewsData(url: self.presenter.generateUrl(page: 2)) { [weak self] art in
             guard let self = self else { return }
            DispatchQueue.main.async {
                let beforeCount = self.articles.count
                self.articles.append(contentsOf: art)
                let insertIndexes = (beforeCount..<self.articles.count).map {IndexPath(row: $0, section: 0) }
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertIndexes, with: .left)
                self.tableView.endUpdates()
            }
        }
    }
}

extension NewsTableVC: TableVCView {
    
    func startActivityIndicator() {
        self.activityInd.startAnimating()
    }
    
    func stopActivityIndicator() {
        self.activityInd.stopAnimating()
    }
    
    func setArticles(articles: [Article]) {
        self.articles = articles
        self.reloadData()
    }
    
    func reloadData() {
        self.tableView.reloadData()
        self.refresh.endRefreshing()
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
