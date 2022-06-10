//
//  MealImageTableViewCell.swift
//  RecipeBrowser
//
//  Created by Emily Rainer on 6/9/22.
//

import UIKit
import moa

// MARK: - MealImageTableViewCell
class MealImageTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mealImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Functions
    func setup(meal: Meal) {
        mealImageView.moa.url = meal.mealThumb
        Moa.errorImage = UIImage(named: "image-not-found.png")
    }
    
}
