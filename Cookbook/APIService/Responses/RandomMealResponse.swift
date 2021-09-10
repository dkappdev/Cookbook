//
//  RandomMealResponse.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 10.09.2021.
//

import Foundation

/// Stores meal information for a random meal
public struct RandomMealResponse {
    public var mealInfo: FullMealInfo
}

extension RandomMealResponse: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AnyCodingKey.self)
        
        let mealInfos = try values.decode([FullMealInfo].self, forKey: AnyCodingKey(stringValue: "meals"))
        
        if mealInfos.count != 1 {
            fatalError("Invalid server response")
        }
        
        mealInfo = mealInfos.first!
    }
}
