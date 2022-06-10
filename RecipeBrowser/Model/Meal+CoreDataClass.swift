//
//  Meal+CoreDataClass.swift
//  RecipeBrowser
//
//  Created by Emily Rainer on 6/9/22.
//
//

import Foundation
import CoreData


public class Meal: NSManagedObject {
    
    // MARK: - Properties
    public static let entityName = "Meal"
    
    // MARK: - Functions
    
    // Used to fetch Meal entities from core data
    static func fetchMeal(mealID: String) -> Meal? {
        do {
            let fetchRequest: NSFetchRequest<Meal> = Meal.fetchRequest()
            fetchRequest.fetchLimit = 1
            let predicate = NSPredicate(format: "id == %@", mealID)
            fetchRequest.predicate = predicate
            
            let meals = try CoreDataManager.shared.viewContext().fetch(fetchRequest)
            var mealWithPermanentID: Meal?
            for meal in meals {
                if !meal.objectID.isTemporaryID {
                    mealWithPermanentID = meal
                }
            }
            return mealWithPermanentID
            
        } catch let error as NSError {
            print("Error fetching meals from core data: \(error.localizedDescription)")
            return nil
        }
    }
}
