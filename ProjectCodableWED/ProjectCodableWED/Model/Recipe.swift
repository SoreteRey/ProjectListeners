//
//  Recipe.swift
//  ProjectCodableWED
//
//  Created by Sebastian Guiscardo on 3/1/23.
//

import Foundation

struct RecipeTopLevelDictionary: Decodable {
    let meals: [Recipe]
}

struct Recipe: Decodable {
    private enum CodingKeys: String, CodingKey {
        case mealID = "idMeal"
        case mealName = "strMeal"
        case category = "strCategory"
        case areaOfOrigin = "strArea"
    }
    let mealID: String
    let mealName: String
    let category: String
    let areaOfOrigin: String
}
