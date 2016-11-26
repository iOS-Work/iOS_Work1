//
//  File.swift
//  Memo
//
//  Created by TaiyangLiu on 2016/11/26.
//  Copyright © 2016年 Liu. All rights reserved.
//

import Foundation
import UIKit
class Memo: NSObject {
    var mContent: String!
    var mImage: UIImage!
    var mTime: String!
    init?(mContent: String, mImage: UIImage?, mTime: String?) {
        if mContent.isEmpty {
        return nil
        }
        self.mContent = mContent
        self.mImage = mImage
        self.mTime = mTime
        super.init()
    }
    convenience init?(_ mContent: String)
    { self.init(mContent: mContent,
                mImage: nil,
                mTime: nil) }
}
