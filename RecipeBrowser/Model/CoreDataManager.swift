//
//  CoreData.swift
//  RecipeBrowser
//
//  Created by Emily Rainer on 6/8/22.
//

import CoreData

// MARK: - CoreDataManager
public class CoreDataManager {
    
    // MARK: - Properties
    public static let shared = CoreDataManager()
    
    private init() {
    }
    
    var context: NSManagedObjectContext {
        let container = NSPersistentContainer(name: "RecipeBrowser")
        container.loadPersistentStores(completionHandler: {
            persistentStoreDescription, error in
            guard error == nil else {
                fatalError("Failed to load store: \(String(describing: error))")
            }
        })
        return container.viewContext
    }
    
    //
    // MARK: - Core Data stack
    //
    var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "RecipeBrowser")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                //fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
            }
        }
    }
    
    func viewContext() -> NSManagedObjectContext {
        let viewContext = persistentContainer.viewContext
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
        return viewContext
    }
}
