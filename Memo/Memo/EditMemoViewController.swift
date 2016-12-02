//
//  EditMemoViewController.swift
//  Memo
//
//  Created by 刘琦 on 2016/11/26.
//  Copyright © 2016年 Liu. All rights reserved.
//

import UIKit
import CoreLocation
import JZLocationConverter

class EditMemoViewController: UIViewController, CLLocationManagerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let locationManager : CLLocationManager = CLLocationManager()
    var memo: MemoDataMO?
    var positionInfo: String = ""
    var initTime = [Int]()
    var time = ""
    var day = ""
    var currentLocation : CLLocation!
    var networkStatus = 1

    
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
    
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minuteTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var dayTextField: UITextField!
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
            let alertController = UIAlertController(title: "数据无效", message: "备忘录的内容不能为空", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "确定", style:.cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "unwindToShowMemo", sender: self)
            gmStatus = 0
        }
    }
    
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
        if networkStatus == 1 {
            locationManager.requestAlwaysAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLLocationAccuracyKilometer
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            JKLOG("network")
        } else {
            JKLOG("no network")
        }
        
        initTime = getTimes()
        
        if memo?.memoDay == nil {
        hourTextField.text = String(initTime[3])
        minuteTextField.text = String(initTime[4])
        yearTextField.text = String(initTime[0])
        monthTextField.text = String(initTime[1])
        dayTextField.text = String(initTime[2])
        } else {
            hourTextField.text = memo?.memoHour
            minuteTextField.text = memo?.memoMinute
            yearTextField.text = memo?.memoYear
            monthTextField.text = memo?.memoMonth
            dayTextField.text = memo?.memoDate

        }
        
    }
    // 获取当前时间
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
            time = hourTextField.text! + ":" + minuteTextField.text!
            day = yearTextField.text! + "年" + monthTextField.text! + "月" + dayTextField.text! + "日"
            let mTime = time
            let mDay = day
            let hour = hourTextField.text
            let minute = minuteTextField.text
            let year = yearTextField.text
            let month = monthTextField.text
            let date = dayTextField.text
            print(time)
            print(day)
            
            if memo == nil { // add a new entry
                self.memo = appDelegate.addToContext(memoContent: content!,photo: photo,time: mTime,day: mDay,hour: hour,minute: minute,year: year,month: month,date: date,memoColor: color)
            } else { // updating the existing entry
                appDelegate.updateToContext(memo: memo!, content: content!,photo: photo,time: mTime,day: mDay,hour: hour,minute: minute,year: year,month: month,date: date,memoColor: color)
            }
        }
    }
    
    //MARK:CLLocationManagerDelegate
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        //定位成功
//        currentLocation = locations.last //取出经纬度
//        //37.785834  122.406417
//        //39.95264  116.34375
////        currentLocation.coordinate.longitude = 116.34375
////        currentLocation.coordinate.latitude = 39.95264
//        JKLOG(currentLocation.coordinate.longitude)
//        JKLOG(currentLocation.coordinate.latitude)
//        LonLatToCity()//去调用转换
//    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //定位失败
        JKLOG(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let changeLocation:NSArray =  locations as NSArray
        let currentLocation = changeLocation.lastObject
        
        currentLatitude = (currentLocation as AnyObject).coordinate.latitude
        currentLongitude = (currentLocation as AnyObject).coordinate.longitude
        JKLOG("\(currentLatitude)\n\(currentLongitude)")
//        let locationCoord:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: currentLatitude,longitude: currentLongitude)
//        37.785834  122.406417
//        39.95264  116.34375
        let locationCoord:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: bjLatitude,longitude: bjLongitude)
        let position = JZLocationConverter.bd09(toGcj02: locationCoord) //好像没有多大变化
        ////////////需要转化为高德地图的经纬度才行
        JKLocationManager.shared.jkReverseGeocoder(location: position) { (reGeocode, error) in
            if (error != nil) {
                JKLOG(error?.localizedDescription)
                print ("location1: "+"\(currentPosition)")
            } else {
                currentPosition = (reGeocode?.formattedAddress)!
                JKLOG ("location2: "+"\(currentPosition)")
                //修改地理位置
                self.positionLabel.text = (reGeocode?.formattedAddress)!
            }
        }
        
//        只调用一次，获取地图之后就可以先暂停了
        locationManager.stopUpdatingLocation()
    }
    
    //定位ios自带地图
    func LonLatToCity() {
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { (placemark, error) -> Void in
            if(error == nil) {
                let array = placemark! as NSArray
                let mark = array.firstObject as! CLPlacemark
                let city  = mark.country
                JKLOG(city)
//                let formattedAddressLines: NSString = ((mark.addressDictionary! as NSDictionary).value(forKey: "FormattedAddressLines") as AnyObject).firstObject as! NSString
//                //这是具体位置
//                let name: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "Name") as! NSString
//                //这是区
//                let subLocality: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "SubLocality") as! NSString
//     
//                JKLOG(formattedAddressLines)
//                JKLOG(name)
//                JKLOG(subLocality)
                self.positionLabel.text = city
            } else {
                //定位失败
                JKLOG(error)
                self.positionLabel.text = "定位失败"
            }
        }
        //只调用一次，获取地图之后就可以先暂停了
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func unwindToList(segue:UIStoryboardSegue) {
        if segue.identifier == "unwindToList" {
//            positionLabel.text = positionInfo
            print("aaa")
        }
    }
    
    @IBAction func unwindSaveToList(segue:UIStoryboardSegue) {
        if segue.identifier == "unwindSaveToList" {
            if positionInfo != "" {
                positionLabel.text = positionInfo
            }
            print("bbb")
        }
    }
    
    @IBAction func unwindToEditMemo(segue:UIStoryboardSegue) {
        if segue.identifier == "unwindToEditMemo" ,
            let detailViewController = segue.destination as? DetailViewController,
            let memo1 = detailViewController.memo{
            memo = memo1
        }
    }
    

    
    //判断网络状态
    let reachability = Reachability()!
    
    func NetworkStatusListener() {
        //设置网络状态消息监听
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    deinit {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
    }
    
    // 主动检测网络状态
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            networkStatus = 1
            print("网络连接：可用")
            if reachability.isReachableViaWiFi {
                print("连接类型：WiFi")
            } else {
                print("连接类型：移动网络")
            }
            //定位的button设置为可选
            positionButton.isEnabled = true
//            LonLatToCity()
        } else {
            networkStatus = 0
            print("网络连接：不可用")
            DispatchQueue.main.async {
                // 不加这句导致界面还没初始化完成就打开警告框，很奇怪？？
                self.alert_noNetwrok() // 警告框，提示没有网络
            }
            //定位的button设置为不可选
            positionButton.isEnabled = false
        }
    }
    
    func alert_noNetwrok() -> Void {
        let alert = UIAlertController(title: "系统提示", message: "网络连接错误，无法正常加载定位", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

}


