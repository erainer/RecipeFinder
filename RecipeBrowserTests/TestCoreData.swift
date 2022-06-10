//
//  TestCoreData.swift
//  RecipeBrowserTests
//
//  Created by Emily Rainer on 6/9/22.
//

import XCTest
import CoreData
@testable import RecipeBrowser

class TestCoreData: XCTestCase {
    
    var mealEntity: Meal?
    var recipeEntity: Recipe?
    var mealID = "52970"
    let context = CoreDataManager.shared.viewContext()
    
    override func setUp() {
        super.setUp()
        
        guard let recipeEntityDescription =
                NSEntityDescription.entity(forEntityName: RecipeBrowser.Recipe.entityName,
                                           in: context),
              let mealEntityDescription =
                NSEntityDescription.entity(forEntityName: RecipeBrowser.Meal.entityName,
                                           in: context) else {
                    XCTFail()
                    return
        }
        
        // Initialize recipe entity
        recipeEntity = RecipeBrowser.Recipe(entity: recipeEntityDescription, insertInto: context)
        recipeEntity?.id = "53049"
        recipeEntity?.thumb = "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg"
        recipeEntity?.name = "Apam balik"
        
        
        // Initialize meal entity
        mealEntity = RecipeBrowser.Meal(entity: mealEntityDescription, insertInto: context)
        mealEntity?.id = mealID
        mealEntity?.name = "Tunisian Orange Cake"
        mealEntity?.instructions = "Preheat oven to 190 C / Gas 5. Grease a 23cm round springform tin.\r\nCut off the hard bits from the top and bottom of the orange."
        mealEntity?.mealThumb = "https://www.themealdb.com/images/media/meals/y4jpgq1560459207.jpg"
        mealEntity?.ingredients = ["strIngredient1": "Orange",
                             "strIngredient2": "Caster Sugar"]
        mealEntity?.measurements = ["strMeasure1": "1 large",
                              "strMeasure2": "300g"]
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRecipesCoreData() {
        let recipeRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Recipe.entityName)
        
        do {
            var recipes: [Recipe] = []
            if let recipeData = try context.fetch(recipeRequest) as? [Recipe] {
                recipes.append(contentsOf: recipeData)
            }
            
            XCTAssertTrue(recipes.count != 0)
        } catch {
            XCTFail()
        }
    }
    
    func testMealCoreData() {
        let mealRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Meal.entityName)
        mealRequest.fetchLimit = 1
        let predicate = NSPredicate(format: "id == %@", mealID)
        mealRequest.predicate = predicate

        do {
            var storedMeal: Meal?
            if let mealData = try context.fetch(mealRequest) as? [Meal] {
                for meal in mealData {
                    storedMeal = meal
                }
            }
            
            guard let unwrappedMeal = storedMeal else {
                XCTFail()
                return
            }
            
            XCTAssertTrue(unwrappedMeal.id == mealID)
        } catch {
            XCTFail()
        }
    }
}


