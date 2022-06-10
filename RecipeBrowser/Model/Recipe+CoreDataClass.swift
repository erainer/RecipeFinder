//
//  Recipe+CoreDataClass.swift
//  RecipeBrowser
//
//  Created by Emily Rainer on 6/9/22.
//
//

import Foundation
import CoreData


public class Recipe: NSManagedObject {
    // MARK: - Properties
    public static let entityName = "Recipe"
    
    // MARK: - Functions
    
    // Used to fetch Recipe entities from core data
    public static func fetchRecipes() -> [Recipe] {
        do {
            let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
            
            let recipes = try CoreDataManager.shared.viewContext().fetch(fetchRequest)
            
            return recipes
            
        } catch let error as NSError {
            print("Error fetching recipes from core data: \(error.localizedDescription)")
            return []
        }
    }
}
