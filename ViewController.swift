//
//  ViewController.swift
//  JCWebImage
//
//  Created by CXY on 16/12/1.
//  Copyright © 2016年 CXY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let str = "https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo_top_ca79a146.png"
        imageView.jc_setImageWithURLString(urlString: str)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

