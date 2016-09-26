//
//  SEDetailInfoModel.swift
//  SellEasierS
//
//  Created by huan on 16/9/13.
//  Copyright © 2016年 huan. All rights reserved.
//

import Foundation
import CoreData

class SEDetailInfoModel: NSObject,SEDataModelOperation {
    var infoType: NSNumber
    var nameAndValue: String
    var parentId: String
    var unitId: String
    var updateTime: Date
    
    override init() {
        self.infoType = NSNumber(value: 0)
        self.nameAndValue = ""
        self.parentId = ""
        self.unitId = NSUUID().uuidString.lowercased()
        self.updateTime = Date()
    }
    
    static func modelWithData(data:NSManagedObject?) -> NSObject?{
        if data != nil {
            let model = SEDetailInfoModel()
            model.infoType = (data?.value(forKey: "infoType") ?? NSNumber(value: 0)) as! NSNumber
            model.nameAndValue = (data?.value(forKey: "nameAndValue") ?? "") as! String
            model.parentId = (data?.value(forKey: "parentId") ?? "") as! String
            model.unitId = (data?.value(forKey: "unitId") ?? "") as! String
            model.updateTime = (data?.value(forKey: "updateTime") ?? "") as! Date
            return model
        }
        return nil
    }
    
    func save() {
        if !unitId.isEmpty{
            let predicate = NSPredicate(format: "unitId==%@", unitId)
            let datas = SEDataBaseManager.sharedInstance.fetchObject(entityName: SEDataBaseManager.EntityName.detailInfo, predicate: predicate, sortDescriptions: nil, limitNum: 0)
            let detailTemplate: NSManagedObject
            if datas != nil && datas!.count > 0{
                detailTemplate = datas!.first!
            } else {
                detailTemplate = SEDataBaseManager.sharedInstance.insertObject(entityName: SEDataBaseManager.EntityName.detailInfo)
            }
            detailTemplate.setValue(infoType, forKey: "infoType")
            detailTemplate.setValue(nameAndValue, forKey: "nameAndValue")
            detailTemplate.setValue(parentId, forKey: "parentId")
            detailTemplate.setValue(updateTime, forKey: "updateTime")
            SEDataBaseManager.sharedInstance.saveContext()
        }
    }
}
