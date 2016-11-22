//
//  ViewController.swift
//  test1122
//
//  Created by 刘琦 on 2016/11/22.
//  Copyright © 2016年 刘琦. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func smile(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Hello World", message: "Hi, Hello! I am here.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil) // create an OK button
        alertController.addAction(okAction)
        
        // display the alert box
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func helloMessage(_ sender: UIButton) {
        //object
        
    }
    @IBAction func showMessage(_ sender: UIButton) {
        //object
//        let alertController = UIAlertController(title: "Hello World", message: "Hi, Hello! I am here.", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil) // create an OK button
//        alertController.addAction(okAction)
//        
//        // display the alert box
//        present(alertController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

