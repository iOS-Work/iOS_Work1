//
//  UIImageExtension.swift
//  Memo
//
//  Created by 刘琦 on 2016/11/30.
//  Copyright © 2016年 Liu. All rights reserved.
//

import UIKit
extension UIImage {
    class func image(withColor color: UIColor, imageSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        color.set()
        UIRectFill(CGRect.init(origin: CGPoint.zero, size: imageSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
