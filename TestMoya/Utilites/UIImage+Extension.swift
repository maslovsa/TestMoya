//
//  UIImage+Extension.swift
//  TestMoya
//
//  Created by Maslov Sergey on 20.05.18.
//  Copyright © 2017 Maslov Sergey. All rights reserved.
//

import UIKit

extension UIImage { // For Common uses
    
    
    class func fakeImageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y:0), size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

extension UIImage { // TestMoya use
    
    static var stubImage: UIImage {
        return self.fakeImageWithColor(color: UIColor.lightGray)
    }
    
    static var searchCancel: UIImage {
        return UIImage(named:"icon_search_cancel")!
    }
    
    static var noResults: UIImage {
        return UIImage(named:"icon_noresult")!  ///img_no_results
    }
    
    static var featured: UIImage {
        return UIImage(named:"icon_gold_star")!
    }
    
    static var unFeatured: UIImage {
        return UIImage(named:"icon_empty_star")!
    }

}
