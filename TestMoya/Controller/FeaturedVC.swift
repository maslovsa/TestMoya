//
//  FeaturedVC.swift
//  TestMoya
//
//  Created by Maslov Sergey on 20.05.18.
//  Copyright © 2017 Maslov Sergey. All rights reserved.
//

import UIKit
import PureLayout

class FeaturedVC: UIViewController {
    
    class func assemblyVC() -> FeaturedVC {
        let vc = FeaturedVC(nibName: nil, bundle: nil)
        vc.model = FeaturedModel()
        vc.model.output = vc
        return vc
    }
    
    var model: FeaturedModelInput!
    
    fileprivate var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        initTableView()
        
        model.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Featured"
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
    
    // MARK: - Private functions
    fileprivate func updateContent() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension FeaturedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.repositories.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < model.repositories.count else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(type: DetailRepoTableCell.self)
        cell.configure(model.repositories[indexPath.row])
        cell.actionDelegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FeaturedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DetailRepoTableCell.cellHeight
    }
}

// MARK: - FeaturedModelOutput
extension FeaturedVC: FeaturedModelOutput {
    func dataUpdated() {
        DispatchQueue.main.async {
            self.updateContent()
        }
    }
}

// MARK: - DetailRepoTableCellDelegate
extension FeaturedVC: DetailRepoTableCellDelegate{
    func clickFeature(_ cell: BaseRepoTableCell) {
        model.featureAction(repo: cell.repo)
    }
}
