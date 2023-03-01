//
//  CategoryListTableViewController.swift
//  ProjectCodableWED
//
//  Created by Sebastian Guiscardo on 3/1/23.
//

import UIKit

class CategoryListTableViewController: UITableViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllCategories()
    }
    // MARK: - Properties
    var categoryArray: [Category] = []
    
    // MARK: - Function
    func fetchAllCategories() {
        MealService.fetchAllCategories { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categoryArray = categories
                DispatchQueue.main.async { self?.tableView.reloadData() }
            case .failure(let error):
                print(error.errorDescription ?? Constants.Error.unkownError)
            }
        }
    }
    
    func configureCell(cell: UITableViewCell, category: Category) {
        var config = cell.defaultContentConfiguration()
        
        config.text = category.categoryName
        config.textProperties.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        config.secondaryText = category.description
        config.secondaryTextProperties.font = UIFont.systemFont(ofSize: 14, weight: .light)
        //        config.secondaryTextProperties.numberOfLines = 5
        
        
        
        cell.contentConfiguration = config
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        configureCell(cell: cell, category: category)
        
        return cell
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMealListVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? MealListTableViewController else { return }
            let category = categoryArray[indexPath.row]
            destinationVC.category = category
        }
    }
}
