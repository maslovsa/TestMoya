//
//  ViewController.swift
//  TestMoya
//
//  Created by Sergey Maslov on 19.05.2018.
//  Copyright © 2018 Sergey Maslov. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {

    let provider = MoyaProvider<MyService>()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

