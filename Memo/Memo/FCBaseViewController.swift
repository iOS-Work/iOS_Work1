//
//  FCBaseViewController.swift
//  Memo
//
//  Created by 刘琦 on 2016/11/30.
//  Copyright © 2016年 Liu. All rights reserved.
//

import UIKit
import Foundation


class FCBaseViewController: UIViewController {
    lazy var dataArray = { return [AnyObject]() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    deinit {
        NSLog("\(self.classForCoder)已释放")
    }
    
    open func jk_popViewController(animated: Bool) -> Void{
        _ = self.navigationController?.popViewController(animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
