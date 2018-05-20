//
//  UISearchBar+Extension.swift
//  TestMoya
//
//  Created by Maslov Sergey on 20.05.18.
//  Copyright © 2017 Maslov Sergey. All rights reserved.
//

import UIKit

extension UISearchBar {
    func setCursorColor(_ color: UIColor) {
        // Loop into it's subviews and find TextField, change tint color to something else.
        for subView in self.subviews[0].subviews  {
            if let textField = subView as? UITextField {
                textField.tintColor = color
            }
        }
    }
    
    public func setTextColor(_ color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
    
    public func setTextFont(_ font: UIFont) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.font = font
    }
}
