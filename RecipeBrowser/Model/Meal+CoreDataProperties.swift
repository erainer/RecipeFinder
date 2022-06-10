//
//  Meal+CoreDataProperties.swift
//  RecipeBrowser
//
//  Created by Emily Rainer on 6/9/22.
//
//

import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal")
    }

    @NSManaged public var area: String?
    @NSManaged public var category: String?
    @NSManaged public var drinkAlternate: String?
    @NSManaged public var id: String?
    @NSManaged public var ingredients: [String: String]?
    @NSManaged public var instructions: String?
    @NSManaged public var link: String?
    @NSManaged public var mealThumb: String?
    @NSManaged public var measurements: [String: String]?
    @NSManaged public var name: String?
    @NSManaged public var tags: String?
    @NSManaged public var imgSource: String?
    @NSManaged public var creativeCommonsConfirmed: String?
    @NSManaged public var dateModified: String?

}

extension Meal : Identifiable {

}
