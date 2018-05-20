//
//  SearchTableCell.swift
//  TestMoya
//
//  Created by Maslov Sergey on 20.05.18.
//  Copyright © 2017 Maslov Sergey. All rights reserved.
//

import UIKit

class SearchTableCell: BaseRepoTableCell {
    static let cellHeight: CGFloat = 55.0
        
    private let specialLabel = UILabel.newAutoLayout()
    private let fullnameLabel = UILabel.newAutoLayout()
    
    override func localInit() {
        self.selectionStyle = .none
        contentView.backgroundColor = UIColor.white
        
        contentView.addSubview(fullnameLabel)
        fullnameLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 4, left: 10, bottom: 20, right: 0))
        fullnameLabel.textAlignment = .left
        fullnameLabel.textColor = UIColor.black
        
        contentView.addSubview(specialLabel)
        specialLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 20, left: 10, bottom: 4, right: 0))
        specialLabel.textAlignment = .left
        specialLabel.textColor = UIColor.gray
    }
    
    override func configure(_ repo: RepoDefinition) {
        super.configure(repo)
        
        specialLabel.text = "id: \(repo.id!)"
        fullnameLabel.text = repo.fullName ?? "no title"
        
        contentView.backgroundColor = repo.isFeatured ? UIColor.yellow : UIColor.white
    }
}
