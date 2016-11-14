////
////  SEDetailTemplateDataManager.swift
////  SellEasierS
////
////  Created by huan on 2016/10/25.
////  Copyright © 2016年 huan. All rights reserved.
////
//
//import Foundation
//
//class SEDetailTemplateDataManager {
////    var templateModels: SEDetailTemplateModel?
////    class func loadTemplate(templateId: String) -> () {
////        
////    }
//    
//     func loadTemplate(detailType:SECommon.DetailType) -> ([SEDetailTemplateModel]?) {
//        var templateModels: [SEDetailTemplateModel] = []
//        let str = "detailType==\(detailType.rawValue)"
//        let predicate : NSPredicate = NSPredicate(format: str, argumentArray: nil)
//        let templateDatas = SEDataBaseManager.sharedInstance.fetchObject(entityName: SEDataBaseManager.EntityName.detailTemplate, predicate: predicate, sortDescriptions: nil, limitNum: 0)
//        if templateDatas != nil {
//            
//            for data in templateDatas! {
//                let model = SEDetailTemplateModel.modelWithData(data: data)
//                if model != nil {
//                    templateModels.append(model! as! SEDetailTemplateModel)
//                }
//            }
//            return templateModels
//        }
//        return nil
//    }
//}
