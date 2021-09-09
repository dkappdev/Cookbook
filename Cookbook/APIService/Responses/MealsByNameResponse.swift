//
//  MealsByNameResponse.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 09.09.2021.
//

import Foundation

public struct MealsByNameResponse {
    public var mealInfos: [FullMealInfo]?
}

extension MealsByNameResponse: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AnyCodingKey.self)
        
        mealInfos = try values.decode([FullMealInfo]?.self, forKey: AnyCodingKey(stringValue: "meals"))
    }
}
