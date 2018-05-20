//
//  UITableView+Extension.swift
//  TestMoya
//
//  Created by Maslov Sergey on 20.05.18.
//  Copyright © 2017 Maslov Sergey. All rights reserved.
//

import UIKit

extension UITableView
{
    
    public func dequeueReusableCell< T: UITableViewCell >(type: T.Type) -> T
    {
        guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: type)) as? T else {
            fatalError("\(String(describing: type)) cell could not be instantiated because it was not found on the tableView")
        }
        
        return cell
    }
    
}
