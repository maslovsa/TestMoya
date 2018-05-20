//
//  DetailRepoTableCell.swift
//  TestMoya
//
//  Created by Maslov Sergey on 20.05.18.
//  Copyright © 2017 Maslov Sergey. All rights reserved.
//

import UIKit

protocol DetailRepoTableCellDelegate: class {
    func clickFeature(_ cell: BaseRepoTableCell)
}

class DetailRepoTableCell: BaseRepoTableCell {
    static let cellHeight: CGFloat = 155.0
    weak var actionDelegate: DetailRepoTableCellDelegate?
    
    private let interItemOffset: CGFloat = 15.0
    private let fullnameLabel = UILabel.newAutoLayout()
    private let descriptionLabel = UILabel.newAutoLayout()
    private let ownerFullnameLabel = UILabel.newAutoLayout()
    private let ownerEmailLabel = UILabel.newAutoLayout()
    private let featureButton = UIButton.init(type: .custom)
    
    override func localInit() {
        self.selectionStyle = .none
        backgroundColor = UIColor.black
        
        contentView.addSubview(fullnameLabel)
        fullnameLabel.autoPinEdge(.left, to: .left, of: contentView, withOffset: interItemOffset)
        fullnameLabel.autoPinEdge(.right, to: .right, of: contentView, withOffset: interItemOffset)
        fullnameLabel.autoPinEdge(.top, to: .top, of: contentView, withOffset: interItemOffset)
        fullnameLabel.textAlignment = .left
        fullnameLabel.textColor = UIColor.white
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.autoPinEdge(.left, to: .left, of: contentView, withOffset: interItemOffset)
        descriptionLabel.autoPinEdge(.right, to: .right, of: contentView, withOffset: interItemOffset)
        descriptionLabel.autoPinEdge(.top, to: .bottom, of: fullnameLabel, withOffset: interItemOffset)
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = UIColor.darkGray
        
        contentView.addSubview(ownerFullnameLabel)
        ownerFullnameLabel.autoPinEdge(.left, to: .left, of: contentView, withOffset: interItemOffset)
        ownerFullnameLabel.autoPinEdge(.right, to: .right, of: contentView, withOffset: interItemOffset)
        ownerFullnameLabel.autoPinEdge(.top, to: .bottom, of: descriptionLabel, withOffset: interItemOffset)
        ownerFullnameLabel.textAlignment = .left
        ownerFullnameLabel.textColor = UIColor.gray
        
        contentView.addSubview(ownerEmailLabel)
        ownerEmailLabel.autoPinEdge(.left, to: .left, of: contentView, withOffset: interItemOffset)
        ownerEmailLabel.autoPinEdge(.right, to: .right, of: contentView, withOffset: interItemOffset)
        ownerEmailLabel.autoPinEdge(.top, to: .bottom, of: ownerFullnameLabel, withOffset: interItemOffset)
        ownerEmailLabel.textAlignment = .left
        ownerEmailLabel.textColor = UIColor.gray
        
        contentView.addSubview(featureButton)
        featureButton.configureForAutoLayout()
        featureButton.autoSetDimensions(to: CGSize(width:60, height:60))
        featureButton.autoAlignAxis(.horizontal, toSameAxisOf: contentView)
        featureButton.autoPinEdge(.right, to: .right, of: contentView)
        featureButton.contentMode = .scaleAspectFit
        featureButton.addTarget(self, action: #selector(DetailRepoTableCell.clickRecommend), for: .touchUpInside)
    }
    
    override func configure(_ repo: RepoDefinition) {
        super.configure(repo)
        
        let fullName = repo.fullName ?? "no title"
        fullnameLabel.text = "Repo Fullname: \(fullName)"
        
        let description = repo.repoDescription ?? "no description"
        descriptionLabel.text = "Repo Description: \(description)"
        
        let ownerFullname = repo.owner?.fullName ?? "no name"
        ownerFullnameLabel.text = "Owner Fullname: \(ownerFullname)"
        
        let ownerEmail = repo.owner?.email ?? "no email"
        ownerEmailLabel.text = "Owner Email: \(ownerEmail)"
        
        featureButton.setImage(repo.isFeatured ? UIImage.featured :  UIImage.unFeatured, for: .normal)
    }
    
    @objc func clickRecommend() {
        actionDelegate?.clickFeature(self)
    }
}
