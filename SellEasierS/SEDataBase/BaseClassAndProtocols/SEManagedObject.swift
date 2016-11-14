//
//  ManagedObject.swift
//  SellEasierS
//
//  Created by huan on 2016/11/11.
//  Copyright © 2016年 huan. All rights reserved.
//

import Foundation
import CoreData

public class SEManagedObject: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var updateTime: Date
}


public class SEValue: SEManagedObject {
    @NSManaged public var valueType: NSNumber
    @NSManaged public var value: String
}

public class SETemplateValue: SEManagedObject {
    @NSManaged public var valueType: NSNumber
}

public struct SETempValue {
    var sort: Int
    var name: String
    var value: String
    var valueType: Int
    var updateTime: Date
    init() {
        sort = 0
        name = ""
        value = ""
        valueType = 0
        updateTime = Date()
    }
}

public struct SETempTemplateValue {
    public var name: String
    public var updateTime: Date
    public var valueType: NSNumber

    init() {
        name = ""
        updateTime = Date()
        valueType = 0
    }
}



