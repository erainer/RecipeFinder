//
//  ViewController.swift
//  RecipeBrowser
//
//  Created by Emily Rainer on 6/8/22.
//

import UIKit

// MARK: - RecipeViewController
class RecipeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var recipeTableView: UITableView!
    
    // MARK: - Properties
    let recipeCellIdentifier: String = "RecipeCell"
    let mealSegueIdentifier: String = "mealSegue"
    var recipes: [Recipe] = []
    var currentSelectedIndex: Int = -1
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recipeTableView.delegate = self
        NetworkLayer.shared.getRecipes(completion: { recipes in
            self.recipes = self.sortRecipesAlphabetically(recipes: recipes)
            DispatchQueue.main.async {
                self.recipeTableView.reloadData()
            }
        })
    }
    
    // MARK: - Functions
    
    // Sort recipes alphabetically
    func sortRecipesAlphabetically(recipes: [Recipe]) -> [Recipe] {
        let sortedRecipes = recipes.sorted {
            $0.name < $1.name
        }
        
        return sortedRecipes
    }
}

// MARK: - TableViewDelegate
extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Number of cells in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    // Setup details for cell in table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = recipeTableView.dequeueReusableCell(withIdentifier: recipeCellIdentifier) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setup(recipe: recipes[indexPath.row])
        
        return cell
    }
    
    // Navigate to new view when table view row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let mealViewController = storyboard?.instantiateViewController(withIdentifier: "MealViewController") as? MealViewController {
            mealViewController.id = recipes[indexPath.row].id
            navigationController?.pushViewController(mealViewController, animated: true)
        }
    }
    
    // Table view row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
