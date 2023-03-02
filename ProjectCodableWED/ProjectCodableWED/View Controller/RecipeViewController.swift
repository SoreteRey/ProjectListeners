//
//  RecipeViewController.swift
//  ProjectCodableWED
//
//  Created by Sebastian Guiscardo on 3/2/23.
//

import UIKit

class RecipeViewController: UIViewController {
// MARK: - Outlets
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeAreaLabel: UILabel!
    @IBOutlet weak var youtubeLabel: UILabel!
    @IBOutlet weak var recipeInstructionsLabel: UILabel!
    @IBOutlet weak var recipeTableViewLabel: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTableViewLabel.dataSource = self
        fetchRecipe()
    }
    
  // MARK: - Properties
    var meal: Meal?
    var recipe: Recipe?
    
  // MARK: - Functions
    func fetchRecipe() {
        guard let meal = meal else { return }
        MealService.fetchRecipe(forMeal: meal) { [weak self] result in
            switch result {
            case .success(let recipe):
                self?.recipe = recipe
                DispatchQueue.main.async { self?.updateUI(withRecipe: recipe) }
            case .failure(let error):
                print(error.errorDescription ?? Constants.Error.unkownError)
            }
        }
    }
    
    
    func updateUI(withRecipe recipe: Recipe) {
        recipeNameLabel.text = recipe.mealName
        recipeAreaLabel.text = recipe.areaOfOrigin
        youtubeLabel.text = recipe.youtubeLink
        recipeInstructionsLabel.text = recipe.instructions
        recipeTableViewLabel.reloadData()
        fetchRecipeImage()
    }
    
    func fetchRecipeImage() {
        MealService.fetchImage(for: recipe?.imageURL) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async { self?.recipeImageView.image = image }
            case .failure(let error):
                print(error.errorDescription ?? Constants.Error.unkownError)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInstructionsVC" {
            guard let recipe = recipe,
                  let destinationVC = segue.destination as? InstructionsViewController else { return }
            destinationVC.instructions = recipe.instructions
        }
    }
}
// MARK: - Extensions

extension RecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe?.ingredients.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipeTableViewLabel.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        
        guard let ingredient = recipe?.ingredients[indexPath.row] else { return UITableViewCell() }
        
        var config = cell.defaultContentConfiguration()
        config.text = ingredient.name
        config.secondaryText = ingredient.measurement
        cell.contentConfiguration = config
        
        return cell
    }
}
