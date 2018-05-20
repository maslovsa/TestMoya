//
//  BaseRepoTableCell.swift
//  TestMoya
//
//  Created by Maslov Sergey on 20.05.18.
//  Copyright © 2017 Maslov Sergey. All rights reserved.
//
import UIKit

class BaseRepoTableCell: UITableViewCell {
    var repo: RepoDefinition!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        localInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        localInit()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        localInit()
    }
    
    func localInit() {
        
    }
    
    func configure(_ repo: RepoDefinition) {
        self.repo = repo
    }
    
}
