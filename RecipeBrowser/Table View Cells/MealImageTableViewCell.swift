//
//  MealImageTableViewCell.swift
//  RecipeBrowser
//
//  Created by Emily Rainer on 6/9/22.
//

import UIKit

class MealImageTableViewCell: UITableViewCell {

    @IBOutlet weak var mealImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(meal: Meal) {
        guard let image = meal.mealThumb else {
            return
        }
        mealImageView.image = UIImage(named: "image-not-found.png")
        //mealImageView.image = UIImage(named: image)
    }
    
}
