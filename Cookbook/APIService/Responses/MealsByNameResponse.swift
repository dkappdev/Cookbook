//
//  MealsByNameResponse.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 09.09.2021.
//

import Foundation

/// Stores information for all meals returned by `MealsByNameRequest`
public struct MealsByNameResponse {
    public var mealInfos: [FullMealInfo]?
}

extension MealsByNameResponse: Decodable {
    public enum CodingKeys: String, CodingKey {
        case mealInfos = "meals"
    }
}
