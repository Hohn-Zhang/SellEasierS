//
//  SESellerValue.swift
//  SellEasierS
//
//  Created by huan on 2016/11/11.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

public final class SESellerValue: SEValue {
    @NSManaged internal var seller: SESeller
}

extension SESellerValue: SEManagedObjectType {
    public static var entityName: String {
        return "SESellerValue"
    }
}
