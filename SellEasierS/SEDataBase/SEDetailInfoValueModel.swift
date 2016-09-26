//
//  SEDetailInfoValueModel.swift
//  SellEasierS
//
//  Created by huan on 16/9/13.
//  Copyright © 2016年 huan. All rights reserved.
//

import Foundation
import CoreData

class SEDetailInfoValueModel: NSObject,SEDataModelOperation {
    var sortOrder: NSNumber
    var unitId: String
    var updateTime: Date
    var valueId: String
    var valueName: String
    var valueStr: String
    var valueType: NSNumber
    
    override init() {
        self.valueName = ""
        self.sortOrder = NSNumber(value: 0)
        self.valueType = NSNumber(value: 0)
        self.unitId = ""
        self.updateTime = Date()
        self.valueId = NSUUID().uuidString.lowercased()
        self.valueStr = ""
    }
    
    init(name:String,unitId:String,sortOrder:Int,valueType:Int) {
        self.valueName = name
        self.sortOrder = NSNumber(value: sortOrder)
        self.valueType = NSNumber(value: valueType)
        self.unitId = unitId
        self.updateTime = Date()
        self.valueId = NSUUID().uuidString.lowercased()
        self.valueStr = ""
    }
    
    static func modelWithData(data:NSManagedObject?) -> NSObject?{
        if data != nil {
            let model = SEDetailInfoValueModel()
            
            model.unitId = (data!.value(forKey: "unitId") ?? "") as! String
            
            model.sortOrder = (data!.value(forKey: "sortOrder") ?? NSNumber(value: 0)) as! NSNumber
            
            model.updateTime = (data!.value(forKey: "updateTime") ?? Date()) as! Date
            
            model.valueId = (data!.value(forKey: "valueId") ?? "") as! String
            
            model.valueName = (data!.value(forKey: "valueName") ?? "") as! String
            model.valueStr = (data!.value(forKey: "valueStr") ?? "") as! String
            
            model.valueType = (data!.value(forKey: "valueType") ?? NSNumber(value: 0)) as! NSNumber
            return model
        }
        return nil
    }
    
    func save() {
        if !valueId.isEmpty{
            let predicate = NSPredicate(format: "valueId==%@", valueId)
            let datas = SEDataBaseManager.sharedInstance.fetchObject(entityName: SEDataBaseManager.EntityName.detailInfoValue, predicate: predicate, sortDescriptions: nil, limitNum: 0)
            let detailValue: NSManagedObject
            if datas != nil && datas!.count > 0{
                detailValue = datas!.first!
            } else {
                detailValue = SEDataBaseManager.sharedInstance.insertObject(entityName: SEDataBaseManager.EntityName.detailInfoValue)
            }
            detailValue.setValue(unitId, forKey: "unitId")
            detailValue.setValue(sortOrder, forKey: "sortOrder")
            detailValue.setValue(updateTime, forKey: "updateTime")
            detailValue.setValue(valueName, forKey: "valueName")
            detailValue.setValue(valueStr, forKey: "valueStr")
            detailValue.setValue(valueType, forKey: "valueType")
            SEDataBaseManager.sharedInstance.saveContext()
        }
    }
}
