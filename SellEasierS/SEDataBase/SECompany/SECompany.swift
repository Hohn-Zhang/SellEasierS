//
//  SECompany.swift
//  SellEasierS
//
//  Created by huan on 2016/11/11.
//  Copyright © 2016年 huan. All rights reserved.
//

import Foundation

public final class SECompany: SEManagedObject {
    @NSManaged internal var sellers: Set<SESeller>?
    @NSManaged internal var products: Set<SEProduct>?
    @NSManaged internal var values: Set<SECompanyValue>?
}

extension SECompany: SEManagedObjectType {
    public static var entityName: String {
        return "SECompany"
    }
}
