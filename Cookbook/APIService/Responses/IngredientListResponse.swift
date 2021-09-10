//
//  IngredientListResponse.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 10.09.2021.
//

import Foundation

/// Stores information about all available ingredients
public struct IngredientListResponse {
    public var ingredientInfos: [IngredientInfo]
}

extension IngredientListResponse: Decodable {
    public enum CodingKeys: String, CodingKey {
        case ingredientInfos = "meals"
    }
}
