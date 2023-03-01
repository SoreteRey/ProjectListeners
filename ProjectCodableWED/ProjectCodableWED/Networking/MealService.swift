//
//  MealService.swift
//  ProjectCodableWED
//
//  Created by Sebastian Guiscardo on 3/1/23.
//

import Foundation

struct MealService {
    
    static func fetchAllCategories(completion: @escaping (Result<[Category], NetworkError>) -> Void) {
        guard let finalURL = URL(string: Constants.MealService.allCategoriesBaseURl) else {
            completion(.failure(.invalidURL)) ; return }
            print("Fetch All Categories Final URL: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
                return
            }
            if let response = response as? HTTPURLResponse {
                print("Fetch All Categories Status Code: \(response.statusCode)")
            }
            
            guard let data = data else { completion(.failure(.noData)) ; return }
            
            do {
                let topLevel = try JSONDecoder().decode(CategoryTopLevelDictionary.self, from: data)
                completion(.success(topLevel.categories))
            } catch {
                completion(.failure(.unableToDecode))
                return
            }
        }.resume()
    }
    static func fetchMealsInCategory(forCategory category: Category,
                                     completion: @escaping (Result<[Meal], NetworkError>) -> Void) {
        
        guard let baseURL = URL(string: Constants.MealService.mealsInCategoryBaseURL) else { completion(.failure(.invalidURL))
            return
        }
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let categoryQueryItem = URLQueryItem(name: Constants.MealService.categoryQueryKey, value: category.categoryName)
        urlComponents?.queryItems = [categoryQueryItem]
        guard let finalURL = urlComponents?.url else { completion(.failure(.invalidURL)) ; return }
        print("Fetch Meals in Category Final URL: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Fetch Meals in Category Status Code; \(response.statusCode)")
            }
            
            guard let data = data else { completion(.failure(.noData)) ; return }
            
            do {
                let topLevel = try JSONDecoder().decode(MealTopLevelDictionary.self, from: data)
                completion(.success(topLevel.meals))
                return
            } catch {
                completion(.failure(.unableToDecode))
                return
            }
        }.resume()
    }
        
        static func fetchRecipe(forMeal meal: Meal,
                                completion: @escaping (Result<Recipe, NetworkError>) -> Void) {
            
            guard let baseURL = URL(string: Constants.MealService.fetchRecipeBaseURL) else { completion(.failure(.invalidURL)) ; return }
            var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
            let recipeQueryItem = URLQueryItem(name: Constants.MealService.recipeQueryKey, value: meal.mealName)
            urlComponents?.queryItems = [recipeQueryItem]
            guard let finalURL = urlComponents?.url else { completion(.failure(.invalidURL)) ; return }
            print("Fetch Recipe Final URL: \(finalURL)")
            
            URLSession.shared.dataTask(with: finalURL) { data, response, error in
                if let error = error {
                    completion(.failure(.thrownError(error)))
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    print("Fetch Recipe Status Code; \(response.statusCode)")
                }
                
                guard let data = data else { completion(.failure(.noData)) ; return }
                
                do {
                    let topLevel = try JSONDecoder().decode(RecipeTopLevelDictionary.self, from: data)
                    if let recipe = topLevel.meals.first {
                        completion(.success(recipe))
                    } else {
                        completion(.failure(.emptyArray))
                        return
                    }
                } catch {
                    completion(.failure(.unableToDecode))
                    return
                }
            }.resume()
        }
}// end of struct

