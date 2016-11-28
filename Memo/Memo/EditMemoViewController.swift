//
//  EditMemoViewController.swift
//  Memo
//
//  Created by 刘琦 on 2016/11/26.
//  Copyright © 2016年 Liu. All rights reserved.
//

import UIKit

class EditMemoViewController: UIViewController {

    
    @IBAction func getPosition(_ sender: Any) {
        
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two di erent ways.
        if presentingViewController is UINavigationController {
            dismiss(animated: true, completion: nil) } else {
            navigationController!.popViewController(animated: true) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
