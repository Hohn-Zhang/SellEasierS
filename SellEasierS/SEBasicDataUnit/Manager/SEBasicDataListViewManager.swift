//
//  SEBasicDataListViewManager.swift
//  SellEasierS
//
//  Created by huan on 16/9/8.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit
//fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l < r
//  case (nil, _?):
//    return true
//  default:
//    return false
//  }
//}
//
//fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l > r
//  default:
//    return rhs < lhs
//  }
//}

class SEBasicDataListViewManager: SETableViewManager {
    
    var detaiInfolType:SECommon.DetailType?
    var companyDetailInfos: [NSObject] = []
    var productDetailInfos: [NSObject] = []
    var sellerDetailInfos: [NSObject] = []
    
    override init() {
        detaiInfolType = SECommon.DetailType.company
    }
    
    override var data: [NSObject] {
        
        get{
            switch detaiInfolType! {
            case SECommon.DetailType.company:
                return companyDetailInfos
            case SECommon.DetailType.seller:
                return sellerDetailInfos
            case SECommon.DetailType.product:
                return productDetailInfos
            }
        }
        
        set{
            switch detaiInfolType! {
            case SECommon.DetailType.company:
                companyDetailInfos = newValue
            case SECommon.DetailType.seller:
                sellerDetailInfos = newValue
            case SECommon.DetailType.product:
                productDetailInfos = newValue
            }
        }
    }
    
    override func loadDatas() {
        let str = "infoType==" + String(detaiInfolType!.rawValue)
        let predicate : NSPredicate = NSPredicate(format: str, argumentArray: nil)
        let detailInfoDatas = SEDataBaseManager.sharedInstance.fetchObject(entityName: SEDataBaseManager.EntityName.detailInfo, predicate: predicate, sortDescriptions: nil, limitNum: 0)
        var infoModels: Array<NSObject> = []
        if let tempDatas = detailInfoDatas {
            for infoData in tempDatas {
                if let infoModel = SEDetailInfoModel.modelWithData(data: infoData) {
                    infoModels.append(infoModel)
                }
            }
        }

        switch detaiInfolType! {
        case SECommon.DetailType.company:
            companyDetailInfos = infoModels
        case SECommon.DetailType.product:
            productDetailInfos = infoModels
        case SECommon.DetailType.seller:
            sellerDetailInfos = infoModels
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "detailInfoCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SEDetailTableViewCell
        var name:String = ""
        var value:String = ""
        if self.data.count > 0 {
            let valueAndName  = self.data[(indexPath as NSIndexPath).row] as! String
            let arr = valueAndName.components(separatedBy: ",")
            if arr.count > 0 {
                name = arr[0]
                value = arr[1]
            }
        }
        
        if cell != nil {
            cell!.nameLabel.text = name
            cell!.infoLabel.text = value
        } else {
            let nibViews = Bundle.main.loadNibNamed("SEDetailTableViewCell", owner: nil, options: nil)
            if let view = nibViews?.first as? SEDetailTableViewCell{
                cell = view
                cell?.nameLabel.text = name
                cell?.infoLabel.text = value
            }
        }
        
        return cell!
    }
}
