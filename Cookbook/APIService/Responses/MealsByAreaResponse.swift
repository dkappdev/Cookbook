//
//  MealsByAreaResponse.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 10.09.2021.
//

import Foundation

/// Stores information about all meals in an area
public struct MealsByAreaResponse {
    public var mealInfos: [ShortMealInfo]?
}

extension MealsByAreaResponse: Decodable {
    public enum CodingKeys: String, CodingKey {
        case mealInfos = "meals"
    }
}
