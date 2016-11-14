//
//  SESeller.swift
//  SellEasierS
//
//  Created by huan on 2016/11/11.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

public final class SESeller: SEManagedObject {
    @NSManaged internal var company: SECompany?
    @NSManaged internal var products: Set<SEProduct>?
    @NSManaged internal var values: Set<SESellerValue>?
}

extension SESeller: SEManagedObjectType {
    public static var entityName: String {
        return "SESeller"
    }
}
