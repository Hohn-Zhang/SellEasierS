//
//  SEProductValue.swift
//  SellEasierS
//
//  Created by huan on 2016/11/11.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

public final class SEProductValue: SEValue {
    @NSManaged internal var product: SEProduct
}

extension SEProductValue: SEManagedObjectType {
    public static var entityName: String {
        return "SEProductValue"
    }
}
