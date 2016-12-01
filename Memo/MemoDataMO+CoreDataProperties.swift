//
//  MemoDataMO+CoreDataProperties.swift
//  Memo
//
//  Created by TaiyangLiu on 2016/12/1.
//  Copyright © 2016年 Liu. All rights reserved.
//

import Foundation
import CoreData


extension MemoDataMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoDataMO> {
        return NSFetchRequest<MemoDataMO>(entityName: "MemoData");
    }

    @NSManaged public var memoContent: String?
    @NSManaged public var memoImage: Data?
    @NSManaged public var memoPosition: String?
    @NSManaged public var memoDay: Date?
    @NSManaged public var memoTime: Date?
    @NSManaged public var memoColor: Int64

}
