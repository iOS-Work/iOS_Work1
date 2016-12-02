//
//  MemoDataMO+CoreDataProperties.swift
//  Memo
//
//  Created by TaiyangLiu on 2016/12/2.
//  Copyright © 2016年 Liu. All rights reserved.
//

import Foundation
import CoreData


extension MemoDataMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoDataMO> {
        return NSFetchRequest<MemoDataMO>(entityName: "MemoData");
    }

    @NSManaged public var memoColor: String?
    @NSManaged public var memoContent: String?
    @NSManaged public var memoDay: String?
    @NSManaged public var memoImage: Data?
    @NSManaged public var memoPosition: String?
    @NSManaged public var memoTime: String?
    @NSManaged public var memoDate: String?
    @NSManaged public var memoMonth: String?
    @NSManaged public var memoYear: String?
    @NSManaged public var memoMinute: String?
    @NSManaged public var memoHour: String?

}
