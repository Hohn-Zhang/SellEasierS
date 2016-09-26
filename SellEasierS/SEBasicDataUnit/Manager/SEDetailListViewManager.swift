//
//  SEDetailListViewManager.swift
//  SellEasierS
//
//  Created by huan on 16/9/8.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

class SEDetailListViewManager: SETableViewManager {
    
    open var detailType:SECommon.DetailType?
    
    var detailTemplateModel: SEDetailTemplateModel?
    
    var unitId:String = ""
    
    override func loadDatas() {
        guard unitId.characters.count > 0 else {
            return
        }
        //unitId有值的时候是加载已有detail info 否则，如果有模版则根据选择模版新建，如果没有模版则无数据或创建模版后新建
        if unitId.characters.count > 0 {
            let predicate = NSPredicate(format: "unitId==%@", argumentArray: [unitId])
            let result = SEDataBaseManager.sharedInstance.fetchObject(entityName: SEDataBaseManager.EntityName.detailInfoValue, predicate: predicate, sortDescriptions: nil, limitNum: 0)
            if result != nil && result!.count > 0{
                for infoValue in result! {
                    let infoValueModel = SEDetailInfoValueModel.modelWithData(data: infoValue)
                    if infoValueModel != nil {
                        self.data.append(infoValueModel!)
                    }
                }
            }
        } else {//
            detailTemplateModel =  loadTemplate()
            if detailTemplateModel != nil
                && detailTemplateModel!.templateValue != nil
                && detailTemplateModel!.templateValue!.characters.count > 0 {//根据已有模版新建
                loadDetailInfoValues(templateValue: detailTemplateModel!.templateValue!)
                
            } else {
                
            }
        }
        
    }
    
    //加载模版
    func loadTemplate() -> SEDetailTemplateModel? {
        if detailType != nil {
            let str = "detailType==" + String(detailType!.rawValue)
            let predicate = NSPredicate(format: str, argumentArray: nil)
            let result = SEDataBaseManager.sharedInstance.fetchObject(entityName: SEDataBaseManager.EntityName.detailTemplate, predicate: predicate, sortDescriptions: nil, limitNum: 1)
            if result != nil && result!.count > 0{
                 return SEDetailTemplateModel.modelWithData(data: result![0]) as? SEDetailTemplateModel
            }
        }
        return nil
    }
    
    //根据模版初始化info value
    func loadDetailInfoValues(templateValue:String) {
        if templateValue.characters.count > 0 {
            let data = templateValue.data(using: String.Encoding.utf8)
            
            let jsonDic:[String:[String:String]]? = try! JSONSerialization.jsonObject(
                with: data!,
                options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : [String : String]]
            
            if jsonDic != nil {
                for (name, dic) in jsonDic! {
                    for (sortOrder,valueType) in dic {
                        let valueModel = SEDetailInfoValueModel(name: name, unitId: unitId, sortOrder: Int(sortOrder)!, valueType: Int(valueType)!)
                        self.data.append(valueModel)
                    }
                }
                self.data.sort(by: { (a: NSObject, b: NSObject) -> Bool in
                    let tempA = a as! SEDetailInfoValueModel
                    let tempB = b as! SEDetailInfoValueModel
                    return tempA.sortOrder.intValue < tempB.sortOrder.intValue
                })
            }
        }
    }
}
