//
//  MealListTableViewController.swift
//  ProjectCodableWED
//
//  Created by Sebastian Guiscardo on 3/1/23.
//

import UIKit

class MealListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpActivityIndicator()
        fetchMealsIncategory()
    }
    // MARK: - Properties
    var category: Category?
    var mealArray: [Meal] = []
    var activityIndicator = UIActivityIndicatorView()

    // MARK: - Functions
    func fetchMealsIncategory() {
        guard let category = category else { return }
        MealService.fetchMealsInCategory(forCategory: category) { [weak self] result in
            switch result {
            case .success(let meals):
                self?.mealArray = meals
                self?.stopAnimatingAndReloadData()
//                sleep(1/3)
                DispatchQueue.main.async { self?.tableView.reloadData() }
            case .failure(let error):
                print(error.errorDescription ?? Constants.Error.unkownError)
            }
        }
    }
    
    func setUpActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        self.view.addSubview(activityIndicator)
        self.view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    
    func stopAnimatingAndReloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
        
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath)
        
        let meal = mealArray[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = meal.mealName
        config.secondaryText = meal.mealID
        cell.contentConfiguration = config
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? RecipeViewController else { return }
            let meal = mealArray[indexPath.row]
            destinationVC.meal = meal
        }
    }
}

