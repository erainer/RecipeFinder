//
//  ViewController.swift
//  RecipeBrowser
//
//  Created by Emily Rainer on 6/8/22.
//

import UIKit

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
    func loadImage(url: String) -> UIImage? {
        guard let url = URL(string: url) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data) ?? nil
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        
        return nil
    }
    
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = recipeTableView.dequeueReusableCell(withIdentifier: recipeCellIdentifier) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        
        if let imageUrl =  recipes[indexPath.row].thumb,
           let image = loadImage(url: imageUrl) {
            cell.recipeImage.image = image
        } else {
            cell.recipeImage.image = UIImage(named: "image-not-found.png")
        }
        
        cell.recipeNameLabel.text = recipes[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let mealViewController = storyboard?.instantiateViewController(withIdentifier: "MealViewController") as? MealViewController {
            mealViewController.id = recipes[indexPath.row].id
            navigationController?.pushViewController(mealViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
