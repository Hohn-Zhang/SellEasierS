//
//  SEProductTemplate.swift
//  SellEasierS
//
//  Created by huan on 2016/11/11.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

public final class SEProductTemplate: SEManagedObject {
    @NSManaged internal var values: Set<SEProductTemplateValue>?
}

extension SEProductTemplate: SEManagedObjectType {
    public static var entityName: String {
        return "SEProductTemplate"
    }
}
