//
//  ViewController.swift
//  lvcode
//
//  Created by Lv Qiang on 10/28/2021.
//  Copyright (c) 2021 Lv Qiang. All rights reserved.
//

import UIKit
import lvcode

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = AlertView.alert(title: "", message: "", cancelButtonTitle: "", otherButtonTitle: "") { result in
            
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

