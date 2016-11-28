//
//  DetailViewController.swift
//  Memo
//
//  Created by TaiyangLiu on 2016/11/28.
//  Copyright © 2016年 Liu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var memo: Memo?
    
    @IBOutlet weak var memoContent: UITextView!
    
    @IBAction func editMemo(_ sender: UIButton) {
        

            
    }
    @IBAction func cancel(_ sender: UIButton) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two di erent ways.
        if presentingViewController is UINavigationController {
            dismiss(animated: true, completion: nil) } else {
            navigationController!.popViewController(animated: true) }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        memoContent.text = memo?.mContent
//        if let photo = person?.photo {
//            photoImageView.image = photo } else {
//            photoImageView.image = UIImage(named:"photoalbum") }
//        notesTextView.text = person?.notes
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
