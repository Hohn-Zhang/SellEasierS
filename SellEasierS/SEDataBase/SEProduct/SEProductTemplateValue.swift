//
//  SEProductTemplateValue.swift
//  SellEasierS
//
//  Created by huan on 2016/11/11.
//  Copyright © 2016年 huan. All rights reserved.
//

import Foundation

public final class SEProductTemplateValue: SETemplateValue {
    @NSManaged internal var template: SEProductTemplate?
}

extension SEProductTemplateValue: SEManagedObjectType {
    public static var entityName: String {
        return "SEProductTemplateValue"
    }
}
