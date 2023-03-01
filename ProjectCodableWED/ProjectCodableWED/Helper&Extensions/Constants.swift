//
//  Constants.swift
//  ProjectCodableWED
//
//  Created by Sebastian Guiscardo on 3/1/23.
//

import Foundation

struct Constants {
    
    struct MealService {
        static let allCategoriesBaseURl = "https://www.themealdb.com/api/json/v1/1/categories.php"
        static let mealsInCategoryBaseURL = "https://www.themealdb.com/api/json/v1/1/filter.php"
        static let categoryQueryKey = "c"
        static let fetchRecipeBaseURL = "https://www.themealdb.com/api/json/v1/1/random.php"
        static let recipeQueryKey = "i"
        }
    
    struct Error {
        static let unkownError = "Unkown Error. call Chase Hill"
    }
    }

