//
//  JKNotificationNameExtension.swift
//  Memo
//
//  Created by 刘琦 on 2016/11/30.
//  Copyright © 2016年 Liu. All rights reserved.
//

import Foundation
extension Notification.Name {
    
    // 自定义全局静态通知名
    public struct JKLocation{
        public static let disable = Notification.Name.init(rawValue: "JKLocationServicesDisable")
    }
    
}
