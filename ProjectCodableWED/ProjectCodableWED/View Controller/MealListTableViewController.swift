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
        
        fetchMealsIncategory()
    }
    // MARK: - Properties
    var category: Category?
    var mealArray: [Meal] = []
//    var

    // MARK: - Functions
    func fetchMealsIncategory() {
        guard let category = category else { return }
        MealService.fetchMealsInCategory(forCategory: category) { [weak self] result in
            switch result {
            case .success(let meals):
                self?.mealArray = meals
                sleep(1/2)
                DispatchQueue.main.async { self?.tableView.reloadData() }
            case .failure(let error):
                print(error.errorDescription ?? Constants.Error.unkownError)
            }
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
    
        }
    }

