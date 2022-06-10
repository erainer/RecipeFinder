//
//  Recipe+CoreDataProperties.swift
//  RecipeBrowser
//
//  Created by Emily Rainer on 6/9/22.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var thumb: String?

}

extension Recipe : Identifiable {

}
