//
//  DetailVC.swift
//  TestMoya
//
//  Created by Maslov Sergey on 20.05.18.
//  Copyright © 2017 Maslov Sergey. All rights reserved.
//

import UIKit
import PureLayout

class DetailVC: UIViewController {
    class func assemblyVC(repo: Repository) -> DetailVC {
        let vc = DetailVC(nibName: nil, bundle: nil)
        vc.model = DetailModel()
        vc.model.output = vc
        vc.model.repo = repo
        return vc
    }
    
    var model: DetailModelInput!

    fileprivate var tableView = UITableView()
    fileprivate let fadeView = UIView().configureForAutoLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        initTableView()
        initFadeView()
        
        model.viewDidLoad()
        model.getUserDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Detail info"
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
        
        let infoButton = UIButton(type: .custom)
        infoButton.bounds.size = CGSize(width: 40, height: 40)
        infoButton.contentMode = .scaleAspectFit
        infoButton.setImage(UIImage.featured, for: .normal)
        infoButton.addTarget(self, action: #selector(showFeaturedVC), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = barButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initTableView() {
        view.addSubview(tableView)
        tableView.separatorStyle = .singleLine
        
        tableView.register(DetailRepoTableCell.self, forCellReuseIdentifier: String(describing: DetailRepoTableCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsetsMake(60, 0, 0, 0))
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    func initFadeView() {
        view.addSubview(fadeView)
        fadeView.autoPinEdgesToSuperviewEdges()
        fadeView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.7)
        
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activity.configureForAutoLayout()
        fadeView.addSubview(activity)
        activity.autoCenterInSuperview()
        activity.startAnimating()
        
        fadeView.alpha = 0.0
    }
    
    // MARK: - Private functions
    fileprivate func updateContent() {
        tableView.reloadData()
    }
    
    @objc func showFeaturedVC() {
        let vc = FeaturedVC.assemblyVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension DetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: DetailRepoTableCell.self)
        cell.configure(model.repo)
        cell.actionDelegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DetailRepoTableCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.featureAction()
    }
}

extension DetailVC: DetailModelOutput {
    func detailsUpdated(isSuccess: Bool) {
        DispatchQueue.main.async {
            self.updateContent()
        }
    }
    
    func didStartSearch() {
        DispatchQueue.main.async {
            self.showView(self.fadeView)
        }
    }
    
    func didFinishSearch() {
        DispatchQueue.main.async {
            self.hideView(self.fadeView)
        }
    }
}

extension DetailVC: DetailRepoTableCellDelegate{
    func clickFeature(_ cell: BaseRepoTableCell) {
         model.featureAction()
    }
}
