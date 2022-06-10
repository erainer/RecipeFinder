//
//  MealViewController.swift
//  RecipeBrowser
//
//  Created by Emily Rainer on 6/8/22.
//

import UIKit

class MealViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mealTableView: UITableView!
    @IBOutlet weak var mealNameLabel: UILabel!
    
    // MARK: - Properties
    var id: String?
    var mealSections: [UITableViewCell] = []
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mealTableView.delegate = self
        if let mealID = id {
            NetworkLayer.shared.getMeal(with: mealID, completion: { meal in
                if let mealDetails = meal {
                    DispatchQueue.main.async {
                        self.buildMealSections(mealDetails: mealDetails)
                        self.mealNameLabel.text = mealDetails.name
                        self.mealTableView.reloadData()
                    }
                }
            })
        }
    }
    
    // MARK: - Functions
    func setupMealTableView() {
        
    }
    
    func ingregientsMeasurementsSection(ingredients: [String], measurements: [String]) {
        guard ingredients.count > 0 && measurements.count > 0 else {
            return
        }
        
    }
    
    func buildMealSections(mealDetails: Meal) {
        mealSections = []
        // Image
        if let cell = Bundle.main.loadNibNamed("MealImageTableViewCell", owner: self, options: nil)?.first as? MealImageTableViewCell {
            cell.setup(meal: mealDetails)
            mealSections.append(cell)
        }
        
        // Ingredients and Measurements
        if let cell = Bundle.main.loadNibNamed("MealDetailsTableViewCell", owner: self, options: nil)?.first as? MealDetailsTableViewCell {
            cell.setup(meal: mealDetails, detailType: .ingredients)
            mealSections.append(cell)
        }
        
        // Instructions
        if let cell = Bundle.main.loadNibNamed("MealDetailsTableViewCell", owner: self, options: nil)?.first as? MealDetailsTableViewCell {
            cell.setup(meal: mealDetails, detailType: .intructions)
            mealSections.append(cell)
        }
    }
    
    func calculateRowHeight(cell: UITableViewCell) -> CGFloat {
        let spacer: CGFloat = 12
        var rowHeight: CGFloat = 0
        if let detailCell = cell as? MealDetailsTableViewCell {
            rowHeight = detailCell.detailTitleLabel.bounds.height + detailCell.detailContentsLabel.bounds.height + (spacer * 3)
        } else if let detailCell = cell as? MealImageTableViewCell {
            rowHeight = detailCell.mealImageView.bounds.height + (spacer * 2)
        }
        
        return rowHeight
    }
}

// MARK: - TableViewDelegate
extension MealViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return mealSections[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateRowHeight(cell: mealSections[indexPath.row])
    }
}
