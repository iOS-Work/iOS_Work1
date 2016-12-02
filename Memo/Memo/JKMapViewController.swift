//
//  JKMapViewController.swift
//  Memo
//
//  Created by 刘琦 on 2016/11/30.
//  Copyright © 2016年 Liu. All rights reserved.
//

import UIKit

class JKMapViewController: FCBaseViewController {
    
    var isSelectedCell: Bool?
    var mapView: MAMapView?
    var tableView: UITableView?
    var hiddenTableView: UITableView?
    var currentPOI: AMapPOI?
    var searchController: UISearchController?
    var searchResultsController: JKMapSearchViewController?
    var flagView: UIView?
    var chosenPosition: String = ""
    
        lazy var searchAPI: AMapSearchAPI = {
            let search = AMapSearchAPI.init()
            search?.delegate = self
            return search!
        }()
    
    //return without save action
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToList", sender: self)
        
    }
    
    //recover the original position action
    @IBAction func recoverAction(_ sender: UIBarButtonItem) {
//        sender.isSelected = true
        self.mapView?.setCenter((self.mapView?.userLocation.coordinate)!, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JKLocationManager.shared.startUpdatingLocation()
        
        // 底层的TableView用来存放searchBar，以实现动画效果
        self.hiddenTableView = UITableView.init(frame: self.view.bounds, style: .plain)
        self.hiddenTableView?.separatorStyle = .none
        self.hiddenTableView?.delegate = self
        self.hiddenTableView?.dataSource = self
        self.hiddenTableView?.backgroundColor = UIColor.white
        self.view.addSubview(self.hiddenTableView!)
        
        // 搜索结果展示
        self.searchResultsController = JKMapSearchViewController.init(style: .plain)
        self.searchResultsController?.delegate = self
        
        // 搜索控制器
        self.searchController = UISearchController.init(searchResultsController: self.searchResultsController)
        self.searchController?.delegate = self
        self.searchController?.searchResultsUpdater = self
        self.searchController?.searchBar.jk_customSearchBar(withPlaceholder: "Search")
        
        // mark
        self.hiddenTableView?.tableHeaderView = self.searchController?.searchBar
        
        // 避免警告
        self.searchController?.loadViewIfNeeded()
        
        // mapview
        let mapViewFrame = CGRect.init(x: 0, y: 108, width: JKScreenWidth(), height: JKScreenHeight()*0.4)
        self.mapView = MAMapView.init(frame: mapViewFrame)
        self.mapView?.showsUserLocation = true
        self.mapView?.delegate = self
        self.mapView?.mapType = .standard
        self.mapView?.showsCompass = true
        self.mapView?.userTrackingMode = .follow
        self.mapView?.showsScale = true
        self.mapView?.distanceFilter = 300
        self.mapView?.desiredAccuracy = kCLLocationAccuracyBest
        self.view.addSubview(self.mapView!)
        
        //39.95264  116.34375
        let coordinate = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(bjLatitude), longitude: CLLocationDegrees(bjLongitude))
        self.mapView?.setCenter(coordinate, animated: true)
        
        self.mapViewUpdateAnnotation(withCoordinate: coordinate)
        JKLOG("come into map")
        JKLOG("\(coordinate)")
        JKLOG("\(currentLatitude)") //信息的对的！！！
        
//        self.mapViewUpdateAnnotation(withCoordinate: coordinate)
        //初始化也应该加上选择的位置是当前位置！！！！！！！！
        /////////////////////////获取地图信息
//        self.mapViewUpdateAnnotation(withCoordinate: (mapView?.centerCoordinate)!)
//        let location = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(item.location.latitude), longitude: CLLocationDegrees(item.location.longitude))
//        self.mapView?.setCenter(location, animated: true)
        /////////////////////////
        
        // 黑色的中心点
        let flagView = UIView.init()
        flagView.bounds = CGRect.init(x: 0, y: 0, width: 10, height: 10)
        flagView.backgroundColor = UIColor.black
        flagView.center = (self.mapView?.center)!
        self.view.addSubview(flagView)
        self.flagView = flagView
        
        // 监听定位使能
        NotificationCenter.default.addObserver(self, selector: #selector(JKMapViewController.didReceive(notification:)), name: NSNotification.Name.JKLocation.disable, object: nil)
        
        // 底部显示结果的tableView
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: JKMaxYOfView(self.mapView!), width: JKScreenWidth(), height: JKScreenHeight() - JKMaxYOfView(self.mapView!)), style: .plain)
        self.tableView?.backgroundColor = UIColor.white
        self.tableView?.allowsSelection = true
        self.tableView?.tintColor = UIColor.red
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view .addSubview(self.tableView!)

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let span = MACoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MACoordinateRegion.init(center: JKLocationManager.shared.userLocation!, span: span)
        self.mapView?.setRegion(region, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.locationToUserPosition(sender: nil)
    }
    
    
    final func locationToUserPosition(sender: UIButton?) {
        sender?.isSelected = true
        self.mapView?.setCenter((self.mapView?.userLocation.coordinate)!, animated: true)
    }
    
    final func didReceive(notification: Notification) {
        self.jk_popViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension JKMapViewController: MAMapViewDelegate{
    
    // 位置范围改变，反地理编码
    func mapView(_ mapView: MAMapView!, regionDidChangeAnimated animated: Bool) {
        JKLOG("regionDidChangeAnimated")
        if (self.isSelectedCell == false){
            self.mapViewUpdateAnnotation(withCoordinate: mapView.centerCoordinate)
        }
        self.isSelectedCell = false
    }
    
    // 根据坐标反地理编码，获取位置信息
    func mapViewUpdateAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) -> Void {
        JKLocationManager.shared.jkReverseGeocoder(location: coordinate) { (regeocode, error) in
            self.currentPOI = nil
            self.dataArray.removeAll()
            for poiItem in (regeocode?.pois)!{
//                JKLOG("\(poiItem)") //上面是搜索栏对应的信息
                self.dataArray.append(poiItem)
            }
            self.tableView?.reloadData()
        }
    }
    
}

extension JKMapViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.tableView){
            return self.dataArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == self.tableView){
            let cell = JKLocationTableViewCell.cell(withTableView: tableView)
            let item: AMapPOI = self.dataArray[indexPath.row] as! AMapPOI
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = item.address
            return cell
        }
        
        var cell: UITableViewCell? = UITableViewCell.init(style: .default, reuseIdentifier: "JKTempCellKey")
        if (cell == nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "JKTempCellKey")
            cell?.selectionStyle = .none
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (tableView == self.tableView){
            return 55.0
        }
        return JKScreenHeight() - 108
    }
    
    //根据经纬度获取地图数据!!!!!！！！很奇怪，初始化时候经纬度对应数据不正确
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == self.tableView){
//            JKLOG(self.dataArray[indexPath.row])
            // 选中某个位置，在地图中间显示
            self.isSelectedCell = true
            let item: AMapPOI = self.dataArray[indexPath.row] as! AMapPOI
            self.currentPOI = item
            let location = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(item.location.latitude), longitude: CLLocationDegrees(item.location.longitude))
            self.mapView?.setCenter(location, animated: true)
            chosenPosition = item.name
        }
    }
}


extension JKMapViewController: JKMapSearchViewControllerDelegate {
    // 选中搜索的结果
    func jkMapSearchViewController(didSelected item: AMapTip, addr: String) {
        self.searchController?.isActive = false
        let coordinate = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(item.location.latitude), longitude: CLLocationDegrees(item.location.longitude))
        self.mapView?.setCenter(coordinate, animated: true)
        self.mapViewUpdateAnnotation(withCoordinate: coordinate)
        chosenPosition = addr
    }
}


extension JKMapViewController: UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate{
    
    // POI搜索
    func updateSearchResults(for searchController: UISearchController) {
        let request: AMapInputTipsSearchRequest = AMapInputTipsSearchRequest.init()
        request.keywords = searchController.searchBar.text
//        request.types = "生活服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|公司企业|道路附属设施|地名地址信息|公共设施"
        request.city = JKLocationManager.shared.currentCity
        self.searchAPI.aMapInputTipsSearch(request)
    }
    
    // searchController出现
    func willPresentSearchController(_ searchController: UISearchController) {
        self.mapView?.openGLESDisabled = true
        UIView.animate(withDuration: 0.25) {
            self.mapView?.y(64)
            self.tableView?.y((self.mapView?.frame.maxY)!)
            self.flagView?.center = (self.mapView?.center)!
        }
    }
    
    // searchController显示
    func willDismissSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.3, animations: {
            self.mapView?.y(108)
            self.tableView?.y((self.mapView?.frame.maxY)!)
            self.flagView?.center = (self.mapView?.center)!
        }) { (finished) in
            self.mapView?.openGLESDisabled = false
        }
    }
}

extension JKMapViewController: AMapSearchDelegate {
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        JKLOG(error.localizedDescription)
    }
    
    // POI搜索结果
    func onInputTipsSearchDone(_ request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
        if (response.tips.count > 0){
            self.searchResultsController?.searchResults.removeAll()
            for tip in response.tips {
                self.searchResultsController?.searchResults.append(tip)
            }
        }
        self.searchResultsController?.tableView.reloadData()
    }
    
    // 反向地理编码结果
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        if (response.regeocode.pois.count > 0){
            self.dataArray.removeAll()
            for poi in response.regeocode.pois {
                self.dataArray.append(poi)
            }
        }
        self.tableView?.reloadData()
        self.tableView?.selectRow(at: NSIndexPath.init(row: 0, section: 0) as IndexPath, animated: true, scrollPosition: .bottom)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "unwindToList" {
            
        } else if segue.identifier == "unwindSaveToList", let editMemoViewController = segue.destination as? EditMemoViewController {
            print("\(chosenPosition)")
            editMemoViewController.positionInfo = chosenPosition
        }
    }
   
}
