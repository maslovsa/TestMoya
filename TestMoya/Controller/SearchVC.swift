//
//  SearchVC.swift
//  TestMoya
//
//  Created by Maslov Sergey on 20.05.18.
//  Copyright © 2017 Maslov Sergey. All rights reserved.
//

import UIKit
import PureLayout

class SearchVC: UIViewController {
    class func assemblyVC() -> SearchVC {
        let vc = SearchVC(nibName: nil, bundle: nil)
        vc.model = SearchModel()
        vc.model.output = vc
        return vc
    }
    
    var model: SearchModelInput!
    
    let noResultsHeight:CGFloat = 200
    let searchBarHeight:CGFloat = 44
    fileprivate var tableView = UITableView()
    fileprivate let searchBar = UISearchBar().configureForAutoLayout()
    fileprivate let noResultsView = UIView().configureForAutoLayout()
    fileprivate let fadeView = UIView().configureForAutoLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        initTableView()
        initSearchBar()
        initNoResultsView()
        initFadeView()
        
        
        updateLastSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Search Repos"
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
        
        let infoButton = UIButton(type: .custom)
        infoButton.bounds.size = CGSize(width: 40, height: 40)
        infoButton.contentMode = .scaleAspectFit
        infoButton.setImage(UIImage.featured, for: .normal)
        infoButton.addTarget(self, action: #selector(showFeaturedVC), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = barButton
        
        model.viewWillAppear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initTableView() {

        view.addSubview(tableView)
        tableView.separatorStyle = .singleLine
        
        tableView.register(SearchTableCell.self, forCellReuseIdentifier: String(describing: SearchTableCell.self))
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsetsMake(60 + searchBarHeight, 0, 0, 0))
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    func initFadeView() {
        view.addSubview(fadeView)
        fadeView.autoPinEdge(toSuperviewEdge: .bottom)
        fadeView.autoPinEdge(toSuperviewEdge: .left)
        fadeView.autoPinEdge(toSuperviewEdge: .right)
        fadeView.autoPinEdge(.top, to: .bottom, of: searchBar)
        fadeView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.7)
        
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activity.configureForAutoLayout()
        fadeView.addSubview(activity)
        activity.autoCenterInSuperview()
        activity.startAnimating()
        
        fadeView.alpha = 0.0
    }
    
    func initSearchBar() {
        view.addSubview(searchBar)
        searchBar.autoSetDimension(.height, toSize: searchBarHeight)
        searchBar.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 60,left: 0,bottom: 0,right: 0), excludingEdge: .bottom)
        searchBar.delegate = self
        
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .black
        searchBar.backgroundColor = UIColor.black
        
        searchBar.setTextColor(UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0))
        searchBar.setTextFont(UIFont.systemFont(ofSize: 20, weight: .regular))
        searchBar.tintColor = UIColor(red: 27.0/255.0, green: 116.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        searchBar.setCursorColor(UIColor(red: 27.0/255.0, green: 116.0/255.0, blue: 236.0/255.0, alpha: 1.0))
        searchBar.setImage(UIImage.searchCancel, for: .clear, state: .normal)
        searchBar.setImage(UIImage.searchCancel, for: .clear, state: .highlighted)
    }
    
    func initNoResultsView() {
        view.addSubview(noResultsView)
        noResultsView.autoPinEdge(.top, to: .bottom, of: searchBar)
        noResultsView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .top)
        noResultsView.backgroundColor = UIColor(red: 36.0/255.0, green: 36.0/255.0, blue: 36.0/255.0, alpha: 1.0)
        
        let imageView = UIImageView().configureForAutoLayout()
        noResultsView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        let image = UIImage.noResults
        imageView.image = image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
        imageView.autoSetDimensions(to: CGSize(width:noResultsHeight, height:noResultsHeight))
        imageView.autoCenterInSuperview()
        
        let label = UILabel().configureForAutoLayout()
        noResultsView.addSubview(label)
        label.autoPinEdge(.left, to: .left, of: noResultsView)
        label.autoPinEdge(.right, to: .right, of: noResultsView)
        label.autoPinEdge(.bottom, to: .top, of: imageView)
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.text = "No Results.\nTry more search"
        label.textAlignment = .center
        
        noResultsView.alpha = 0.0
    }
    
    // MARK: - Buttons/Actions
    func launchInfo(with cell: SearchTableCell) {
        let vc = DetailVC.assemblyVC(repo: cell.repo)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showFeaturedVC() {
        let vc = FeaturedVC.assemblyVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Private functions
    fileprivate func updateContent() {
        model.hasUserSearchResults ? hideView(noResultsView) : showView(noResultsView)
        tableView.reloadData()
    }
    
    fileprivate func updateLastSearch() {
        guard let lastSearch = model.getLastSearch() else {
            return
        }
        searchBar.text = lastSearch
        model.search(lastSearch)
    }
    
}

// MARK: - UITableViewDataSource
extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.repositories.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < model.repositories.count else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(type: SearchTableCell.self)
        cell.configure(model.repositories[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchTableCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SearchTableCell {
            launchInfo(with: cell)
        }
    }
}

extension SearchVC: SearchModelOutput {
    func resultsUpdated(isSuccess: Bool) {
        DispatchQueue.main.async {
            self.updateContent()
        }
    }
    
    func didStartSearch() {
        DispatchQueue.main.async {
            self.showView(self.fadeView)
            self.view.bringSubview(toFront: self.fadeView)
            self.hideView(self.noResultsView)
        }
    }
    
    func didFinishSearch() {
        DispatchQueue.main.async {
            self.hideView(self.fadeView)
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        model.search(searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            searchBar.resignFirstResponder()
            return false
        }
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        model.search("")
    }
}
