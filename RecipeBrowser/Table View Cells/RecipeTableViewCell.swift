//
//  RecipeCell.swift
//  RecipeBrowser
//
//  Created by Emily Rainer on 6/8/22.
//

import Foundation
import UIKit
import moa

// MARK: - RecipeTableViewCell
class RecipeTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    // MARK: - Functions
    // Setup Recipe Cell
    func setup(recipe: Recipe) {
        recipeImage.moa.url = recipe.thumb
        Moa.errorImage = UIImage(named: "image-not-found.png")
        recipeNameLabel.text = recipe.name
    }
}
