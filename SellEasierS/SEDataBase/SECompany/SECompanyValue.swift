//
//  SECompanyValue.swift
//  SellEasierS
//
//  Created by huan on 2016/11/11.
//  Copyright © 2016年 huan. All rights reserved.
//

import UIKit

public final class SECompanyValue: SEValue {
    @NSManaged internal var company: SECompany
}

extension SECompanyValue: SEManagedObjectType {
    public static var entityName: String {
        return "SECompanyValue"
    }
}
