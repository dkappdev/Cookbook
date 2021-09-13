//
//  LongMealInfo.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 08.09.2021.
//

import Foundation

/// A type that represents full meal information
public struct FullMealInfo {
    /// Meal ID that can be used to look it up in TheMealDB
    public var mealID: String
    /// Meal display name
    public var mealName: String
    /// Meal category
    public var category: String
    /// Origin area of the meal
    public var areaInfo: AreaInfo
    /// Cooking instructions as a long multiline string
    public var cookingInstructions: String
    /// URL of the meal image
    public var imageURL: URL
    /// URL for cooking video on YouTube
    public var youtubeURL: URL?
    
    /// Cooking ingredients stored as `(String, String)` tuple. The first value represents the ingredient name, and the second one represents measurements.
    public var ingredients: [IngredientAmount]
    
    // MARK: Instances
    
    /// Empty instance of meal information. This is used as a placeholder before actual meal information is loaded from network.
    public static let empty = FullMealInfo(mealID: "", mealName: " ", category: " ", areaInfo: AreaInfo.empty, cookingInstructions: "", imageURL: URL(string: "https://example.org")!, youtubeURL: nil, ingredients: [])
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
        let areaString = try values.decode(String.self, forKey: AnyCodingKey(stringValue: "strArea"))
        areaInfo = AreaInfo(name: areaString)
        cookingInstructions = try values.decode(String.self, forKey: AnyCodingKey(stringValue: "strInstructions"))
        imageURL = try values.decode(URL.self, forKey: AnyCodingKey(stringValue: "strMealThumb"))
        let youtubeURLString = try values.decode(String?.self, forKey: AnyCodingKey(stringValue: "strYoutube"))
        
        if let youtubeURLString = youtubeURLString {
            youtubeURL = URL(string: youtubeURLString)
        }
        
        ingredients = [IngredientAmount]()
        
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
            
            ingredients.append(IngredientAmount(name: ingredient, amount: amount))
        }
    }
}
