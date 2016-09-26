//
//  SERecordModel.swift
//  SellEasierS
//
//  Created by huan on 16/9/13.
//  Copyright © 2016年 huan. All rights reserved.
//

import Foundation

class SERecordModel: NSObject {
    var companyId: String?
    var productId: String?
    var recordType: NSNumber?
    var sellerId: String?
    var updateTime: Date?
    
//    static func modelWithData(data data:SERecord?) -> SERecordModel?{
//        if data != nil {
//            let model = SERecordModel()
//            model.companyId = data?.companyId
//            model.productId = data?.productId
//            model.recordType = data?.recordType
//            model.sellerId = data?.sellerId
//            model.updateTime = data?.updateTime
//            return model
//        }
//        return nil
//    }
}
