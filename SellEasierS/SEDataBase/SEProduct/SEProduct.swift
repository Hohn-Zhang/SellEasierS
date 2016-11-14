//
//  SEProduct.swift
//  SellEasierS
//
//  Created by huan on 2016/11/11.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

public final class SEProduct: SEManagedObject {
    @NSManaged internal var companys: Set<SECompany>
    @NSManaged internal var sellers: Set<SESeller>
    @NSManaged internal var values: Set<SEProductValue>
}

extension SEProduct: SEManagedObjectType {
    public static var entityName: String {
        return "SEProduct"
    }
}
