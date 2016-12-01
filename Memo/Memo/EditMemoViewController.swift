//
//  EditMemoViewController.swift
//  Memo
//
//  Created by 刘琦 on 2016/11/26.
//  Copyright © 2016年 Liu. All rights reserved.
//

import UIKit
import CoreLocation


var time = ""
var day = ""

class EditMemoViewController: UIViewController, CLLocationManagerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let locationManager = CLLocationManager()
    var memo : MemoDataMO?
    
    
    @IBOutlet weak var positionButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBAction func addPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    var colorChoose: String? = "blue"
    @IBOutlet weak var blue: UIButton!
    
    @IBOutlet weak var red: UIButton!
    @IBOutlet weak var yellow: UIButton!
    @IBOutlet weak var green: UIButton!
    @IBOutlet weak var purple: UIButton!
    @IBAction func blueMemo(_ sender: UIButton) {
        colorChoose = "blue"
        
        blue.setImage(UIImage(named:"blue"), for:.normal)
        purple.setImage(UIImage(named:"button2"), for:.normal)
        green.setImage(UIImage(named:"button3"), for:.normal)
        yellow.setImage(UIImage(named:"button4"), for:.normal)
        red.setImage(UIImage(named:"button5"), for:.normal)
    }
    
    
    @IBAction func purpleMemo(_ sender: UIButton) {
        colorChoose = "purple"
        blue.setImage(UIImage(named:"button1"), for:.normal)
        purple.setImage(UIImage(named:"purple"), for:.normal)
        green.setImage(UIImage(named:"button3"), for:.normal)
        yellow.setImage(UIImage(named:"button4"), for:.normal)
        red.setImage(UIImage(named:"button5"), for:.normal)
    }
    
    
    @IBAction func greenMemo(_ sender: UIButton) {
        colorChoose = "green"
        blue.setImage(UIImage(named:"button1"), for:.normal)
        purple.setImage(UIImage(named:"button2"), for:.normal)
        green.setImage(UIImage(named:"green"), for:.normal)
        yellow.setImage(UIImage(named:"button4"), for:.normal)
        red.setImage(UIImage(named:"button5"), for:.normal)
    }
    
    @IBAction func yellowMemo(_ sender: UIButton) {
        colorChoose = "yellow"
        blue.setImage(UIImage(named:"button1"), for:.normal)
        purple.setImage(UIImage(named:"button2"), for:.normal)
        green.setImage(UIImage(named:"button3"), for:.normal)
        yellow.setImage(UIImage(named:"yellow"), for:.normal)
        red.setImage(UIImage(named:"button5"), for:.normal)
    }
    
    @IBAction func redMemo(_ sender: UIButton) {
        colorChoose = "red"
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
        
        if let photoData = memo?.memoImage {
            addPhotoButton.setImage(UIImage(data: photoData), for:.normal)
        } else {
            addPhotoButton.setImage(UIImage(named:"addphoto"), for:.normal)
        }
        
        
        NetworkStatusListener()
        //memo?.memoContent
        // Do any additional setup after loading the view.
        //position
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addPhotoButton.setImage(selectedImage, for:.normal)
            //addPhotoButton.contentMode = .scaleAspectFill
            //addPhotoButton.clipsToBounds = true
        }
        dismiss(animated: true, completion: nil)
        
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
            let color = colorChoose
            let photo = addPhotoButton.image(for: .normal)
            let mTime = time
            let mDay = day
            print(time)
            print(day)
            //let notes = notesTextView.text
            
            if memo == nil { // add a new entry
                self.memo = appDelegate.addToContext(memoContent: content!,photo: photo,time: mTime,day: mDay,memoColor: color)
            } else { // updating the existing entry
                appDelegate.updateToContext(memo: memo!, content: content!,photo: photo,time: mTime,day: mDay,memoColor: color)
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
    

    
    /***** 网络状态监听部分（开始） *****/
    // Reachability必须一直存在，所以需要设置为全局变量
    let reachability = Reachability()!
    
    func NetworkStatusListener() {
        // 1、设置网络状态消息监听 2、获得网络Reachability对象
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            // 3、开启网络状态消息监听
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    // 移除消息通知
    deinit {
        // 关闭网络状态消息监听
        reachability.stopNotifier()
        // 移除网络状态消息通知
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
    }
    
    // 主动检测网络状态
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        // 准备获取网络连接信息
        if reachability.isReachable {
            // 判断网络连接状态
            print("网络连接：可用")
            if reachability.isReachableViaWiFi {
                // 判断网络连接类型
                print("连接类型：WiFi")
            } else {
                print("连接类型：移动网络")
            }
            //定位的button设置为可选
            positionButton.isEnabled = true
        } else {
            print("网络连接：不可用")
            DispatchQueue.main.async {
                // 不加这句导致界面还没初始化完成就打开警告框，这样不行
                self.alert_noNetwrok() // 警告框，提示没有网络
            }
            //定位的button设置为不可选
            positionButton.isEnabled = false
        }
    }
    
    // 警告框，提示没有连接网络
    func alert_noNetwrok() -> Void {
        let alert = UIAlertController(title: "系统提示", message: "网络连接错误，无法正常加载定位", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    /***** 网络状态监听部分（结束）*****/

}

class TimeTableViewController: UITableViewController {
    
    
    @IBOutlet weak var hourTextField: UITextField!
    
    @IBOutlet weak var minuteTextField: UITextField!
    
    @IBOutlet weak var yearTextField: UITextField!
    
    @IBOutlet weak var monthTextField: UITextField!
    
    @IBOutlet weak var dayTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let i = getTimes()
        
        hourTextField.text = String(i[3])
        minuteTextField.text = String(i[4])
        yearTextField.text = String(i[0])
        monthTextField.text = String(i[1])
        dayTextField.text = String(i[2])
        
        time = hourTextField.text! + ":" + minuteTextField.text!
        day = yearTextField.text! + "年" + monthTextField.text! + "月" + dayTextField.text! + "日"

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func getTimes() -> [Int] {
        
        var timers: [Int] = [] //  返回的数组
        
        let calendar: Calendar = Calendar(identifier: .gregorian)
        var comps: DateComponents = DateComponents()
        comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: Date())
        
        timers.append(comps.year!)  // 年 ，后2位数
        timers.append(comps.month!)            // 月
        timers.append(comps.day!)                // 日
        timers.append(comps.hour!)               // 小时
        timers.append(comps.minute!)            // 分钟
        timers.append(comps.second!)            // 秒
        timers.append(comps.weekday! - 1)      //星期
        
        return timers;
    }
  

 }
