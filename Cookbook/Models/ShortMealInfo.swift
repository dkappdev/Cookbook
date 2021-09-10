//
//  ShortMealInfo.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 10.09.2021.
//

import Foundation

/// A type that represents short version of meal information
public struct ShortMealInfo {
    /// Meal ID that can be used to look it up in TheMealDB
    public var mealID: String
    /// Meal display name
    public var mealName: String
    /// URL of the meal image
    public var imageURL: URL
}

extension ShortMealInfo: Decodable {
    public enum CodingKeys: String, CodingKey {
        case mealID = "idMeal"
        case mealName = "strMeal"
        case imageURL = "strMealThumb"
    }
}
