//
//  SEDataBaseManager.swift
//  SellEasierS
//
//  Created by huan on 16/9/8.
//  Copyright © 2016年 huan. All rights reserved.
//

import Foundation
import CoreData


class SEDataBaseManager {
    
//    struct EntityName {
//        static let stock = "SEStock"
//        static let detailInfoValue = "SEDetailInfoValue"
//        static let record = "SERecord"
//        static let detailInfo = "SEDetailInfo"
//        static let detailTemplate = "SEDetailTemplate"
//    }
    //单列
    static let sharedInstance = SEDataBaseManager()
    private init (){}
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "huan.SellEasierS" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "SellEasierS", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    fileprivate lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    //插入一条数据
    func insertObject(entityName:String) -> NSManagedObject {
        let manageObject: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext)
        return manageObject;
    }
    
    func deleteObject(_ obj:NSManagedObject,complete:((Bool)->())?) {
        managedObjectContext.delete(obj)
        if complete != nil {
            complete!(obj.isDeleted)
        }
    }
    
    func fetchObject(entityName:String,predicate:NSPredicate?,sortDescriptions:Array<NSSortDescriptor>?,startIndex: Int?,pageSize:Int?) -> [NSManagedObject]? {

        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:entityName)
        if predicate != nil {
            fetchRequest.predicate = predicate
        }

        fetchRequest.sortDescriptors = sortDescriptions ?? SEDataBaseManager.defaultSortDescriptors

        if startIndex != nil {
            fetchRequest.fetchOffset = startIndex!
        }

        if pageSize != nil {
            fetchRequest.fetchLimit = pageSize!
        }

        if let result = try? managedObjectContext.fetch(fetchRequest) {
            return result as? Array<NSManagedObject>;
        }
        return nil
    }

    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "name", ascending: false)]
    }
}
