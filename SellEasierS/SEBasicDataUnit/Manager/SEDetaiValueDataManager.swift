////
////  SEDetaiValueDataManager.swift
////  SellEasierS
////
////  Created by huan on 2016/10/25.
////  Copyright © 2016年 huan. All rights reserved.
////
//
//import Foundation
//
//class SEDetaiValueDataManager {
//    var unitId: String = ""
//    
//    var modelsFromDB: [SEDetailInfoValueModel]?
//    
//    var modelsByUser: [SEDetailInfoValueModel]?
//    
//    //所有value，包括DB中的与用户新创建的
////    var currentValueModels: [SEDetailInfoValueModel] {
////        get{
////            var tempArray: [SEDetailInfoValueModel] = []
////            if modelsFromDB != nil && modelsFromDB!.count > 0 {
////                tempArray += modelsFromDB!
////            }
////            if modelsByUser != nil && modelsByUser!.count > 0 {
////                tempArray += modelsByUser!
////            }
////            return tempArray
////        }
////    }
//    
//    func loadFromDB(refresh: Bool) -> [SEDetailInfoValueModel]? {
//        
//        if modelsFromDB != nil {
//            if !refresh {
//                return modelsFromDB
//            }
//        }
//        
//        guard unitId.characters.count > 0 else {
//            return nil
//        }
//        
//        modelsFromDB = []
//        let predicate = NSPredicate(format: "unitId==%@", argumentArray: [unitId])
//        let result = SEDataBaseManager.sharedInstance.fetchObject(entityName: SEDataBaseManager.EntityName.detailInfoValue, predicate: predicate, sortDescriptions: nil, limitNum: 0)
//        if result != nil && result!.count > 0{
//            for infoValue in result! {
//                let infoValueModel = SEDetailInfoValueModel.modelWithData(data: infoValue)
//                if infoValueModel != nil {
//                    modelsFromDB!.append(infoValueModel! as! SEDetailInfoValueModel)
//                }
//            }
//        }
//
//        return modelsFromDB
//    }
//    
//    //根据模版初始化info value
//    func loadFromTemplate(template:SEDetailTemplateModel) -> [SEDetailInfoValueModel]? {
//        if template.templateValue != nil && template.templateValue!.characters.count > 0 {
//            
//            let data = template.templateValue!.data(using: String.Encoding.utf8)
//            
//            let jsonDic:[String:[String:String]]? = try! JSONSerialization.jsonObject(
//                with: data!,
//                options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : [String : String]]
//            
//            if jsonDic != nil {
//                var infoValueModels: [SEDetailInfoValueModel] = []
//                for (name, dic) in jsonDic! {
//                    for (sortOrder,valueType) in dic {
//                        let valueModel = SEDetailInfoValueModel(name: name, unitId: unitId, sortOrder: Int(sortOrder)!, valueType: Int(valueType)!)
//                        infoValueModels.append(valueModel)
//                    }
//                }
//                infoValueModels.sort(by: { (a: Any, b: Any) -> Bool in
//                    let tempA = a as! SEDetailInfoValueModel
//                    let tempB = b as! SEDetailInfoValueModel
//                    return tempA.sortOrder.intValue < tempB.sortOrder.intValue
//                })
//                return infoValueModels
//            }
//        }
//        return nil
//    }
//}
