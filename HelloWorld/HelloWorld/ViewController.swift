//
//  ViewController.swift
//  HelloWorld
//
//  Created by 刘琦 on 2016/11/8.
//  Copyright © 2016年 刘琦. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ttt1: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ui = UIImageView(image: #imageLiteral(resourceName: "78cb11bae3c94f405a9b92b9a628e2e3.png"))
        ui.center = view.center
        //view.addSubview(ui)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        //hahahhahahah
        // Dispose of any resources that can be recreated.
    }


}

