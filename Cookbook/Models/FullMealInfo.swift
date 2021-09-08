//
//  LongMealInfo.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 08.09.2021.
//

import Foundation

/// A type that represents full meal information
public struct FullMealInfo {
    var mealID: String
    var mealName: String
    var category: String
    var area: String
    var cookingInstructions: String
    var imageURL: URL
    var youtubeURL: URL
    
    var ingredients: [(String, String)]
}

extension FullMealInfo: Decodable {
    /// Custom initializer that decodes meal information from JSON that is received from TheMealDB
    /// - Parameter decoder: the object that handles the decoding
    /// - Throws: throws an error if decoding failed at some step
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AnyCodingKey.self)
        
        mealID = try values.decode(String.self, forKey: AnyCodingKey(stringValue: "idMeal"))
        mealName = try values.decode(String.self, forKey: AnyCodingKey(stringValue: "strMeal"))
        category = try values.decode(String.self, forKey: AnyCodingKey(stringValue: "strCategory"))
        area = try values.decode(String.self, forKey: AnyCodingKey(stringValue: "strArea"))
        cookingInstructions = try values.decode(String.self, forKey: AnyCodingKey(stringValue: "strInstructions"))
        imageURL = try values.decode(URL.self, forKey: AnyCodingKey(stringValue: "strMealThumb"))
        youtubeURL = try values.decode(URL.self, forKey: AnyCodingKey(stringValue: "strYoutube"))
        
        ingredients = [(String, String)]()
        
        for i in 1...20 {
            var ingredient = try values.decode(String?.self, forKey: AnyCodingKey(stringValue: "strIngredient\(i)"))
            var amount = try values.decode(String?.self, forKey: AnyCodingKey(stringValue: "strMeasure\(i)"))
            
            ingredient = ingredient?.trimmingCharacters(in: .whitespaces)
            amount = amount?.trimmingCharacters(in: .whitespaces)
            
            guard let ingredient = ingredient,
                  let amount = amount,
                  !ingredient.isEmpty,
                  !amount.isEmpty else {
                break
            }
            
            ingredients.append((ingredient, amount))
        }
    }
}
