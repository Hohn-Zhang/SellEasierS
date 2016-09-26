//
//  SEDetailTemplate+CoreDataProperties.swift
//  SellEasierS
//
//  Created by huan on 16/9/8.
//  Copyright © 2016年 huan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SEDetailTemplate {

    @NSManaged var detailType: NSNumber?
    @NSManaged var templateId: UNKNOWN_TYPE
    @NSManaged var templateName: UNKNOWN_TYPE
    @NSManaged var templateValue: UNKNOWN_TYPE

}
