//
//  SEDetailTemplateModel.swift
//  SellEasierS
//
//  Created by huan on 16/9/13.
//  Copyright © 2016年 huan. All rights reserved.
//

import Foundation
import CoreData
class SEDetailTemplateModel: NSObject,SEDataModelOperation {
    var detailType: NSNumber?
    var templateId: String?
    var templateName: String?
    var templateValue: String?
    
    static func modelWithData(data:NSManagedObject?) -> NSObject?{
        if data != nil {
            let model = SEDetailTemplateModel()
            model.detailType = data?.value(forKey: "detailType") as? NSNumber
            model.templateId = data?.value(forKey: "templateId") as? String
            model.templateName = data?.value(forKey: "templateName") as? String
            model.templateValue = data?.value(forKey: "templateValue") as? String
            return model
        }
        return nil
    }
    
    func save() {
        if templateId != nil && !templateId!.isEmpty{
            let predicate = NSPredicate(format: "templateId==%@", templateId!)
            let datas = SEDataBaseManager.sharedInstance.fetchObject(entityName: SEDataBaseManager.EntityName.detailTemplate, predicate: predicate, sortDescriptions: nil, limitNum: 0)
            let detailTemplate: NSManagedObject
            if datas != nil && datas!.count > 0{
                detailTemplate = datas!.first!
            } else {
                detailTemplate = SEDataBaseManager.sharedInstance.insertObject(entityName: SEDataBaseManager.EntityName.detailTemplate)
            }
            detailTemplate.setValue(detailType, forKey: "detailType")
            detailTemplate.setValue(templateId, forKey: "templateId")
            detailTemplate.setValue(templateName, forKey: "templateName")
            detailTemplate.setValue(templateValue, forKey: "templateValue")
            SEDataBaseManager.sharedInstance.saveContext()
        }
    }
}
