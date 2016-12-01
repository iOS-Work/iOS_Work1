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
<<<<<<< HEAD
    
    
    
    
=======

   
//    @IBOutlet weak var buttonBlue: UIButton!
    @IBOutlet weak var memoContent: UITextView!
>>>>>>> origin/master
    let locationManager = CLLocationManager()
    var memo: MemoDataMO?
    @IBOutlet weak var blue: UIButton!
    
    @IBOutlet weak var red: UIButton!
    @IBOutlet weak var yellow: UIButton!
    @IBOutlet weak var green: UIButton!
    @IBOutlet weak var purple: UIButton!
    @IBAction func blueMemo(_ sender: UIButton) {
        memo?.memoColor = 0
        
        blue.setImage(UIImage(named:"blue"), for:.normal)
        purple.setImage(UIImage(named:"button2"), for:.normal)
        green.setImage(UIImage(named:"button3"), for:.normal)
        yellow.setImage(UIImage(named:"button4"), for:.normal)
        red.setImage(UIImage(named:"button5"), for:.normal)
    }
    
    
    @IBAction func purpleMemo(_ sender: UIButton) {
        memo?.memoColor = 1
        blue.setImage(UIImage(named:"button1"), for:.normal)
        purple.setImage(UIImage(named:"purple"), for:.normal)
        green.setImage(UIImage(named:"button3"), for:.normal)
        yellow.setImage(UIImage(named:"button4"), for:.normal)
        red.setImage(UIImage(named:"button5"), for:.normal)
    }
    
    
    @IBAction func greenMemo(_ sender: UIButton) {
        memo?.memoColor = 2
        blue.setImage(UIImage(named:"button1"), for:.normal)
        purple.setImage(UIImage(named:"button2"), for:.normal)
        green.setImage(UIImage(named:"green"), for:.normal)
        yellow.setImage(UIImage(named:"button4"), for:.normal)
        red.setImage(UIImage(named:"button5"), for:.normal)
    }
    
    @IBAction func yellowMemo(_ sender: UIButton) {
        memo?.memoColor = 3
        blue.setImage(UIImage(named:"button1"), for:.normal)
        purple.setImage(UIImage(named:"button2"), for:.normal)
        green.setImage(UIImage(named:"button3"), for:.normal)
        yellow.setImage(UIImage(named:"yellow"), for:.normal)
        red.setImage(UIImage(named:"button5"), for:.normal)
    }
    
    @IBAction func redMemo(_ sender: UIButton) {
        memo?.memoColor = 4
        blue.setImage(UIImage(named:"button1"), for:.normal)
        purple.setImage(UIImage(named:"button2"), for:.normal)
        green.setImage(UIImage(named:"button3"), for:.normal)
        yellow.setImage(UIImage(named:"button4"), for:.normal)
        red.setImage(UIImage(named:"red"), for:.normal)
    }
   
    @IBOutlet weak var memoContent: UITextView!
    
    
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
//        sleep(3000)
//        locationManager.stopUpdatingLocation()
//        buttonBlue.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControlState#>)
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
        currentLatitude = (currentLocation! as AnyObject).coordinate.latitude
        currentLongitude = (currentLocation! as AnyObject).coordinate.longitude
        //////////////
        var showList = [AMapPOI]()
        JKLocationManager.shared.jkReverseGeocoder(location: (currentLocation! as AnyObject).coordinate) { (reGeocode, error) in
            if (error != nil) {
                JKLOG(error?.localizedDescription)
                print ("location1: "+"\(currentPosition)")
            } else {
                for poiItem in (reGeocode?.pois)!{
                    showList.append(poiItem)
                }
                var addr = ""
                for cell in showList {
                    addr += cell.name
                }
                
//                let item: AMapPOI = showList[indexPath.row] as! AMapPOI
//                cell.textLabel?.text = item.name
//                cell.detailTextLabel?.text = item.address
                
//                var addr = reGeocode?.formattedAddress
                currentPosition = addr
//                currentPosition = (reGeocode?.addressComponent.city)!
                JKLOG("\(reGeocode?.formattedAddress)\n\(reGeocode?.addressComponent)")
                print ("location2: "+"\(currentPosition)")
            }
        }
        
        positionLabel.text = "\(currentPosition)"
//        locationManager.stopUpdatingLocation()
        ////////////////
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
