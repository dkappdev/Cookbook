//
//  MealsByCategoryResponse.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 10.09.2021.
//

import Foundation

/// Stores information for all meals for a category
public struct MealsByCategoryResponse {
    public var mealInfos: [ShortMealInfo]?
}

extension MealsByCategoryResponse: Decodable {
    public enum CodingKeys: String, CodingKey {
        case mealInfos = "meals"
    }
}
