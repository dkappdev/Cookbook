//
//  MealByIDResponse.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 09.09.2021.
//

import Foundation

public struct MealByIDResponse {
    public var mealInfo: FullMealInfo?
}

extension MealByIDResponse: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AnyCodingKey.self)
        
        let mealInfos = try values.decode([FullMealInfo]?.self, forKey: AnyCodingKey(stringValue: "meals"))
        
        guard let mealInfos = mealInfos else {
            mealInfo = nil
            return
        }
        
        mealInfo = mealInfos.first
    }
}
