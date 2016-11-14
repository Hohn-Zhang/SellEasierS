//
//  SEBasicDataManager.swift
//  SellEasierS
//
//  Created by huan on 2016/10/24.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

class SEBasicDataManager {

    var detaiInfolType:SECommon.DetailType = SECommon.DetailType.company

    private var companyDatas: [SECompany] = []
    private var productDatas: [SEProduct] = []
    private var sellerDatas: [SESeller] = []

    private var companyCurrentPage: Int = 0
    private var productCurrentPage: Int = 0
    private var sellerCurrentPage: Int = 0

    private var pageSize = 10

    var datas: [SEManagedObject] {
        get{
            switch detaiInfolType {
            case SECommon.DetailType.company:
                return companyDatas
            case SECommon.DetailType.seller:
                return sellerDatas
            case SECommon.DetailType.product:
                return productDatas
            }
        }
        set{
            switch detaiInfolType {
            case SECommon.DetailType.company:
                companyDatas = newValue as! [SECompany]
            case SECommon.DetailType.seller:
                sellerDatas = newValue as! [SESeller]
            case SECommon.DetailType.product:
                productDatas = newValue as! [SEProduct]
            }
        }
    }

    var entityName: String {
        switch detaiInfolType {
        case SECommon.DetailType.company:
            return SECompany.entityName
        case SECommon.DetailType.seller:
            return SECompany.entityName
        case SECommon.DetailType.product:
            return SECompany.entityName
        }
    }

    var currentPage: Int {
        get {
            switch detaiInfolType {
            case SECommon.DetailType.company:
                return companyCurrentPage
            case SECommon.DetailType.seller:
                return sellerCurrentPage
            case SECommon.DetailType.product:
                return productCurrentPage
            }
        }
        set {
            switch detaiInfolType {
            case SECommon.DetailType.company:
                companyCurrentPage = newValue
            case SECommon.DetailType.seller:
                sellerCurrentPage = newValue
            case SECommon.DetailType.product:
                productCurrentPage = newValue
            }
        }
    }

    func loadNextPage() {
        let detailInfoDatas = SEDataBaseManager.sharedInstance.fetchObject(entityName: entityName, predicate: nil, sortDescriptions: nil, startIndex: currentPage, pageSize: pageSize)

        if detailInfoDatas != nil && detailInfoDatas!.count > 0 {
            datas += (detailInfoDatas as! [SEManagedObject])
        } else {
            return
        }
    }
}
