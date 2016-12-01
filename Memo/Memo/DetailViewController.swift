//
//  DetailViewController.swift
//  Memo
//
//  Created by TaiyangLiu on 2016/11/28.
//  Copyright © 2016年 Liu. All rights reserved.
//

import UIKit

var time1 = ""
var day1 = ""

class DetailViewController: UIViewController {

   var memo: MemoDataMO?
    
    @IBOutlet weak var positionButton: UIButton!
    @IBOutlet weak var showPhotoImageView: UIImageView!
    @IBOutlet weak var memoContent: UITextView!
    
    @IBAction func editMemo(_ sender: UIButton) {
        gmStatus = 1
        performSegue(withIdentifier: "unwindToEditMemo", sender: self)

            
    }
    @IBAction func cancel(_ sender: UIButton) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two di erent ways.
        if presentingViewController is UINavigationController {
            dismiss(animated: true, completion: nil) } else {
            navigationController!.popViewController(animated: true) }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        time1 = (memo?.memoTime)!
        day1 = (memo?.memoDay)!
        globalMemo = memo
        memoContent.text = memo?.memoContent
        
        
//        if let photo = person?.photo {
//            photoImageView.image = photo } else {
//            photoImageView.image = UIImage(named:"photoalbum") }
//        notesTextView.text = person?.notes
        // Do any additional setup after loading the view.
        if let photoData = memo?.memoImage {
            showPhotoImageView.image = UIImage(data: photoData)
        } else {
            showPhotoImageView.image = UIImage(named:"photoalbum")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "unwindToEditMemo"
            {
             memo?.memoContent = memoContent.text
        }
        
        
    }


    

}

class ShowTimeTableViewController: UITableViewController {
    
    

    @IBOutlet weak var dayTextField: UILabel!
    @IBOutlet weak var timeTextField: UILabel!
       override func viewDidLoad() {
        super.viewDidLoad()
        
        dayTextField.text = day1
        timeTextField.text = time1
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
        
    
}

