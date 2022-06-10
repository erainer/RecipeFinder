//
//  NetworkManager.swift
//  RecipeBrowser
//
//  Created by Emily Rainer on 6/8/22.
//

import Foundation
import CoreData

// URLs used for requests
struct Urls {
    static let BASE = "https://www.themealdb.com/api/json/v1/1"
    static let RECIPE_SERVICE = "/filter.php?c=Dessert"
    static let MEAL_SERVICE = "/lookup.php?i="
}

// MARK: - NetworkLayer
class NetworkLayer {
    
    // MARK: - Properties
    static let shared = NetworkLayer()
    let context = CoreDataManager.shared.viewContext()
    
    // MARK: - Functions
    
    // Get request for retrieving data from a URL
    func getRequest(url: String, completion: @escaping ([String: AnyObject]) -> Void) {
        
        // Check for any errors with the URL
        guard let urlRequest = URL(string: url) else {
            completion([:])
            return
        }
        
        // Send request to get data
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, response, error in
            
            // Serialize json data
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data,
                                                            options: []) as? [String: AnyObject] {
                completion(json)
            }
            
            completion([:])
        }).resume()
    }
    
    // Download image/file with url
    func download(url: String, toFile file: URL, completion: @escaping (Error?) -> (Void)) {
        // Check for any errors with the URL
        guard let urlRequest = URL(string: url) else {
            completion(nil)
            return
        }
        
        URLSession.shared.downloadTask(with: urlRequest) { tempURL, response, error in
            // Check for any errors
            guard let tempURL = tempURL else {
                completion(error)
                return
            }
            
            do {
                // Remove any existing document at the file path
                if FileManager.default.fileExists(atPath: file.path) {
                    try FileManager.default.removeItem(at: file)
                }
                
                // Copy the tempURL to the file
                try FileManager.default.copyItem(at: tempURL, to: file)
                
                completion(nil)
            } catch let error as NSError {
                completion(error)
            }
            
        }.resume()
    }
    
    // Send a request to get recipes
    func getRecipes(completion: @escaping ([Recipe]) -> ()) {
        let recipesUrl = Urls.BASE + Urls.RECIPE_SERVICE
        getRequest(url: recipesUrl, completion: { json in
            // Parse data from recipe request and store into core data
            self.parseRecipes(json: json, completion: {
                let recipes = Recipe.fetchRecipes()
                completion(recipes)
            })
        })
        
    }
    
    // Send a request to retrieve recipes
    func getMeal(with id: String, completion: @escaping (Meal?) -> ()) {
        let recipesUrl = Urls.BASE + Urls.MEAL_SERVICE + id
        getRequest(url: recipesUrl, completion: { json in
            // Parse data from meal request and store into core data
            self.parseMeals(json: json, completion: {
                let meal = Meal.fetchMeal(mealID: id)
                completion(meal)
            })
        })
        
    }
    
    // Parse recipes json
    func parseRecipes(json: [String: AnyObject], completion: @escaping () -> ()) {
        if let recipes = json["meals"] as? [[String : AnyObject]] {
            
            // Parse feilds for recipe entity
            for recipe in recipes {
                
                guard let id = recipe["idMeal"] as? String,
                      let name = recipe["strMeal"] as? String else {
                          completion()
                          return
                }
                
                let thumb = recipe["strMealThumb"] as? String ?? ""
                
                // Create recipe entity to save into core data
                if let recipeEntityDescription =
                    NSEntityDescription.entity(forEntityName: Recipe.entityName,
                                               in: context) {
                    let recipeEntity = Recipe(entity: recipeEntityDescription, insertInto: context)
                    recipeEntity.id = id
                    recipeEntity.thumb = thumb
                    recipeEntity.name = name
                    
                    synchronizeSaveCoreData()
                }
            }
        }
        
        completion()
    }
    
    // Parse meal json
    func parseMeals(json: [String: AnyObject], completion: @escaping () -> ()) {
        // Parse feilds for meal entity
        if let meals = json["meals"] as? [[String : AnyObject]] {
            for meal in meals {
                
                var ingredients: [String: String] = [:]
                var measurements: [String: String] = [:]
                
                meal.forEach { (key: String, value: AnyObject) in
                    
                    // Merge all ingredients into one variable
                    if key.contains("strIngredient"),
                       let ingredientValue = value as? String,
                       ingredientValue != "" {
                        ingredients[key] = ingredientValue
                    }
                    
                    // Merge all measurements into one variable
                    if key.contains("strMeasure"),
                       let measureValue = value as? String {
                        let filterWhitespaceMeasure = measureValue.filter { !$0.isWhitespace }
                        if filterWhitespaceMeasure != "" {
                            measurements[key] = measureValue
                        }
                    }
                }
                
                // Check to make sure there is a value for the core feilds
                guard let id = meal["idMeal"] as? String,
                      let name = meal["strMeal"] as? String,
                      let instructions = meal["strInstructions"] as? String else {
                          completion()
                          return
                }
                
                let drinkAlternate = meal["strDrinkAlternate"] as? String ?? ""
                let category = meal["strCategory"] as? String ?? ""
                let area = meal["strArea"] as? String ?? ""
                let tags = meal["strTags"] as? String ?? ""
                let link = meal["strYoutube"] as? String ?? ""
                let imgSource = meal["strSource"] as? String ?? ""
                let creativeCommonsConfirmed = meal["strCreativeCommonsConfirmed"] as? String ?? ""
                let dateModified = meal["dateModified"] as? String ?? ""
                let thumb = meal["strMealThumb"] as? String ?? ""
                
                // Create entity for meal and save into core data
                if let mealEntityDescription =
                    NSEntityDescription.entity(forEntityName: Meal.entityName,
                                               in: context) {
                    let mealEntity = Meal(entity: mealEntityDescription, insertInto: context)
                    mealEntity.id = id
                    mealEntity.name = name
                    mealEntity.instructions = instructions
                    mealEntity.mealThumb = thumb
                    mealEntity.drinkAlternate = drinkAlternate
                    mealEntity.category = category
                    mealEntity.area = area
                    mealEntity.tags = tags
                    mealEntity.link = link
                    mealEntity.imgSource = imgSource
                    mealEntity.creativeCommonsConfirmed = creativeCommonsConfirmed
                    mealEntity.dateModified = dateModified
                    mealEntity.ingredients = ingredients
                    mealEntity.measurements = measurements
                    
                    synchronizeSaveCoreData()
                }
            }
        }
        
        completion()
    }
    
    // Synchronously save core data
    func synchronizeSaveCoreData() {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                print("Could not save into core data. \(error), \(error.localizedDescription)")
            }
        }
    }
}
