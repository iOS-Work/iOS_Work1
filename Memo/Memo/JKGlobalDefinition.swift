//
//  JKGlobalDefinition.swift
//  Memo
//
//  Created by 刘琦 on 2016/11/29.
//  Copyright © 2016年 Liu. All rights reserved.
//

import Foundation
import UIKit

var currentLatitude = 0.0
var currentLongitude = 0.0
var currentPosition = "Position"

func iOS8()->Bool{return((UIDevice.current.systemVersion as NSString).floatValue >= 8.0)}
func iOS10()->Bool{return((UIDevice.current.systemVersion as NSString).floatValue >= 10.0)}
func JKScreenWidth() -> CGFloat{return UIScreen.main.bounds.size.width}
func JKScreenHeight() -> CGFloat{return UIScreen.main.bounds.size.height}
func JKMaxYOfView(_ view: UIView) -> CGFloat{return view.frame.origin.y + view.frame.size.height}
var globalMemo : MemoDataMO?
var gmStatus = 0
func JKColor_RGB_Float(r:Float,g:Float,b:Float) -> UIColor {
    return UIColor.init(colorLiteralRed: r, green: g, blue: b, alpha: 1.0)
}
func JKColor_RGB(r:Float,g:Float,b:Float) -> UIColor {
    return UIColor.init(colorLiteralRed: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
}
var globalList = [MemoDataMO]()
var searchText = ""
var searchItems = [String]()
var searchStatus = 0 //0所有都查询，1查询按照空格显示的，2查询点击具体项出现的
func JKLOG<T>(_ log : T,className: String = #file,methodName: String = #function, lineNumber: Int = #line){
    #if DEBUG
        let filePath = className as NSString
        let filePath_copy = filePath.lastPathComponent as NSString
        let fileName = filePath_copy.deletingPathExtension
        NSLog("\n******[第\(lineNumber)行][\(fileName)  \(methodName)] ******\n \(log)")
    #endif
}
