//
//  MealDetailsTableViewCell.swift
//  RecipeBrowser
//
//  Created by Emily Rainer on 6/9/22.
//

import UIKit

enum MealDetailsType: String {
    case intructions = "Instructions"
    case ingredients = "Ingredients and Measurements"
}

// MARK: - MealDetailsTableViewCell
class MealDetailsTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailContentsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Functions
    func setup(meal: Meal, detailType: MealDetailsType) {
        detailTitleLabel.text = detailType.rawValue
        var detailContents: String = ""
        switch detailType {
        case .ingredients:
            guard let ingredients = meal.ingredients,
                  let measurements = meal.measurements else {
                return
            }
            
            // Sort ingredients and measurements to make it easier to combine
            let sortedIngredients = ingredients.sorted { $0.key < $1.key }
            let sortedMeasurements = measurements.sorted { $0.key < $1.key }
            var count = 0
            
            // Loop through ingredients
            sortedIngredients.forEach({ ingredient in
                detailContents += ingredient.value + "\t"
                detailContents += sortedMeasurements[count].value + "\n"
                count += 1
            })
            
        case .intructions:
            guard let intructions = meal.instructions else {
                return
            }
            
            detailContents = intructions
        }
        
        detailContentsLabel.text = detailContents
    }
}
