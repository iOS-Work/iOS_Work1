//
//  JKLocationManager.swift
//  Memo
//
//  Created by 刘琦 on 2016/11/30.
//  Copyright © 2016年 Liu. All rights reserved.
//

import UIKit

/// Block类型别名
public typealias JKGeocodeCompletionHandler = ([AMapGeocode]?, Error?) -> Void
public typealias JKReGeocodeCompletionHandler = (AMapReGeocode?, Error?) -> Void


class JKLocationManager: NSObject,AMapLocationManagerDelegate {
    var geocodeCompletionHandler: JKGeocodeCompletionHandler?
    var reGeocodeCompletionHandler: JKReGeocodeCompletionHandler?
    
    
    // 推荐的单例写法
    static let shared = JKLocationManager()
    private override init() {
        super.init()
        self.initialization()
    }
    
    var appLocationServerEnable: Bool?
    var userLocation: CLLocationCoordinate2D?
    var currentCity: String?
    
    
    
    // getter方法写法
    var globalLocationServerEnable : Bool {
        get {
            return CLLocationManager.locationServicesEnabled()
        }
    }
    
    
    // 懒加载写法
    lazy var locationManager: AMapLocationManager = {
        var manager = AMapLocationManager.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 10.0
        manager.reGeocodeTimeout = 5
        manager.locationTimeout = 5
        return manager
    }()
    lazy var search: AMapSearchAPI = {
        let search = AMapSearchAPI.init()
        search?.delegate = self
        return search!
    }()
    
    
    private func initialization() {
        self.userLocation = CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
    }
    
    ///  获取定位信息
    final func startUpdatingLocation() {
        self.appLocationServerEnable = true
        self.locationManager.startUpdatingLocation()
    }
    
    // 定位成功
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!) {
        manager.stopUpdatingLocation()
        self.appLocationServerEnable = true
        
        if (self.userLocation?.latitude != location?.coordinate.latitude || self.userLocation?.longitude != location?.coordinate.longitude) {
//            JKLOG(self.userLocation?.longitude)
//            JKLOG(location?.coordinate.longitude)
            self.userLocation?.latitude = location.coordinate.latitude
            if ( location.coordinate.longitude > 0){
                self.userLocation?.longitude = location.coordinate.longitude
            } else {
                self.userLocation?.longitude = 0.0 - location.coordinate.longitude
            }
            JKLOG(self.userLocation?.longitude)
            JKLOG(location?.coordinate.longitude)
//            self.userLocation = location?.coordinate
        }
        
        // 获取城市信息
        self.jkReverseGeocoder(location: self.userLocation!) {[weak self] (reGeocode, error) in
            if (error != nil) {
                JKLOG(error?.localizedDescription)
            } else {
                self?.currentCity = reGeocode?.addressComponent.city
//                JKLOG("\(self?.currentCity)")
                JKLOG("\(reGeocode?.formattedAddress)\n\(reGeocode?.addressComponent)")
                JKLOG("定位成功")
            }
        }
    }
    
    // 定位失败
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        self.userLocation = CLLocationCoordinate2D.init(latitude: currentLatitude, longitude: currentLongitude)
        self.appLocationServerEnable = false
        NotificationCenter.default.post(name: NSNotification.Name.JKLocation.disable, object: nil)
        JKLOG("定位失败")
    }
    
    
    /// 测距
    func distance(betweenLocation locationA: CLLocation, andLocation locationB: CLLocation) -> String {
        let locationDistance = locationA.distance(from: locationB)
        return String.init(format: "%.3f", locationDistance/1000.0)
    }
    
}


extension JKLocationManager:AMapSearchDelegate {
    
    /// 正向地理编码（地名-->坐标）
    func jkGeocoder(address: String, city: String?, completionHandler: @escaping JKGeocodeCompletionHandler) -> Void {
        let request = AMapGeocodeSearchRequest.init()
        request.address = address
        request.city = city
        self.search.aMapGeocodeSearch(request)
        self.geocodeCompletionHandler = completionHandler
    }
    
    func onGeocodeSearchDone(_ request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
        self.geocodeCompletionHandler?(response.geocodes,nil)
        self.geocodeCompletionHandler = nil
    }
    
    
    /// 反向地理编码（坐标-->地名）
    func jkReverseGeocoder(location: CLLocationCoordinate2D,completionHandler: @escaping JKReGeocodeCompletionHandler) -> Void {
        let request = AMapReGeocodeSearchRequest.init()
        request.radius = 1000
        let point = AMapGeoPoint.location(withLatitude: CGFloat(location.latitude), longitude: CGFloat(location.longitude))
        request.location = point
        request.requireExtension = true
        self.search.aMapReGoecodeSearch(request)
        JKLOG("\(request.location)") //信息是对的
        self.reGeocodeCompletionHandler = completionHandler
//        JKLOG("\(self.reGeocodeCompletionHandler)")
    }
    
    
    
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        currentCity = response.regeocode.formattedAddress
//        JKLOG("\(currentCity)") //在初始化时候是错的
        self.reGeocodeCompletionHandler?(response.regeocode,nil)
        JKLOG("\(self.reGeocodeCompletionHandler)")
        self.reGeocodeCompletionHandler = nil
    }
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        
        if (self.geocodeCompletionHandler != nil) {
            self.geocodeCompletionHandler?(nil,error)
            self.geocodeCompletionHandler = nil
        }else if (self.reGeocodeCompletionHandler != nil) {
            self.reGeocodeCompletionHandler?(nil,error)
            self.reGeocodeCompletionHandler = nil
        }
        
        JKLOG(error.localizedDescription)
    }
}
