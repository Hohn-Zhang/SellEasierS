//
//  SESellerTemplate.swift
//  SellEasierS
//
//  Created by huan on 2016/11/11.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

public final class SESellerTemplate: SEManagedObject {
    @NSManaged internal var values: Set<SESellerTemplateValue>?
}

extension SESellerTemplate: SEManagedObjectType {
    public static var entityName: String {
        return "SESellerTemplate"
    }
}
