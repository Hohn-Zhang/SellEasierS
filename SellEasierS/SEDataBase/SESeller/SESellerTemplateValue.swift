//
//  SESellerTemplateValue.swift
//  SellEasierS
//
//  Created by huan on 2016/11/11.
//  Copyright © 2016年 huan. All rights reserved.
//

import Foundation

public final class SESellerTemplateValue: SETemplateValue {
    @NSManaged internal var template: SESellerTemplate?
}

extension SESellerTemplateValue: SEManagedObjectType {
    public static var entityName: String {
        return "SESellerTemplateValue"
    }
}
