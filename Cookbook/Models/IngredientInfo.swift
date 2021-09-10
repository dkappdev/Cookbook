//
//  IngredientDescription.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 10.09.2021.
//

import Foundation

public struct IngredientInfo {
    public var ingredientName: String
    public var ingredientDescription: String?
}

extension IngredientInfo: Decodable {
    public enum CodingKeys: String, CodingKey {
        case ingredientName = "strIngredient"
        case ingredientDescription = "strDescription"
    }
}
