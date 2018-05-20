//
//  UIViewController+Extension.swift
//  TestMoya
//
//  Created by Maslov Sergey on 20.05.18.
//  Copyright © 2017 Maslov Sergey. All rights reserved.
//

import UIKit

extension UIViewController {
    func showView(_ view: UIView) {
        guard view.alpha != 1.0 else {
            return
        }
        UIView.animate(withDuration: Constants.Duration.FadeAnimation, animations: {
            view.alpha = 1.0
        })
    }

    func hideView(_ view: UIView) {
        guard view.alpha != 0.0 else {
            return
        }
        UIView.animate(withDuration: Constants.Duration.FadeAnimation, animations: {
            view.alpha = 0.0
        })
    }
}
