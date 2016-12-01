//
//  EditMemoViewController.swift
//  Memo
//
//  Created by 刘琦 on 2016/11/26.
//  Copyright © 2016年 Liu. All rights reserved.
//

import UIKit
import CoreLocation

class EditMemoViewController: UIViewController, CLLocationManagerDelegate {

   
    @IBOutlet weak var memoContent: UITextView!
    let locationManager = CLLocationManager()
    var memo: MemoDataMO?
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBAction func saveMemo(_ sender: UIButton) {
        if memoContent.text == nil || memoContent.text!.isEmpty {
            let alertController = UIAlertController(title: "Invalid Data", message: "The content cannot be empty", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style:.cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "unwindToShowMemo", sender: self)
            gmStatus = 0
        }
    }
    @IBAction func getPosition(_ sender: UIButton) {
//        pushMapVC()
    }
    
//    final func pushMapVC() {
//        let mapVC = JKMapViewController.init()
//        self.navigationController?.pushViewController(mapVC, animated: true)
//    }
    
    @IBAction func cancel(_ sender: UIButton) {
    
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two di erent ways.
        if presentingViewController is UINavigationController {
            dismiss(animated: true, completion: nil)
            gmStatus = 0
        } else {
            navigationController!.popViewController(animated: true) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if gmStatus == 1{
        memo = globalMemo
        memoContent.text = memo?.memoContent
        }
        //memo?.memoContent
        // Do any additional setup after loading the view.
        //position
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
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
        if segue.identifier == "unwindToShowMemo",
            let appDelegate = (UIApplication.shared.delegate as?
            AppDelegate) {
            let content = memoContent.text
            //let photo = photoImageView.image
            //let notes = notesTextView.text
            
            if memo == nil { // add a new entry
                self.memo = appDelegate.addToContext(memoContent: content!)
            } else { // updating the existing entry
                appDelegate.updateToContext(memo: memo!, content: content!)
            }
            }

    }
    
    //MARK: position
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let changeLocation:NSArray =  locations as NSArray
        let currentLocation = changeLocation.lastObject
        //latitude, longitude
        positionLabel.text = "\((currentLocation! as AnyObject).coordinate.latitude, (currentLocation! as AnyObject).coordinate.longitude)"
    }
    @IBAction func unwindToList(segue:UIStoryboardSegue) {
        if segue.identifier == "unwindToList" {
            
        }
    }
    @IBAction func unwindToEditMemo(segue:UIStoryboardSegue) {
        if segue.identifier == "unwindToEditMemo" ,
            let detailViewController = segue.destination as? DetailViewController,
            let memo1 = detailViewController.memo{
            memo = memo1
        }
    }

}
