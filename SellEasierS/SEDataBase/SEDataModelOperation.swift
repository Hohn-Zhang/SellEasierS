//
//  SEDataModel.swift
//  SellEasierS
//
//  Created by huan on 16/9/13.
//  Copyright © 2016年 huan. All rights reserved.
//

import Foundation
import CoreData

protocol SEDataModelOperation {
    
    static func modelWithData(data:NSManagedObject?) -> NSObject?
    
    func save()
} 
