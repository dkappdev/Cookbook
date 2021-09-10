//
//  IngredientImageRequest.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 10.09.2021.
//

import UIKit

/// Request for getting ingredient image
public struct IngredientImageRequest: APIRequest {
    public typealias Response = UIImage
    
    public var path: String { "/images/ingredients/\(ingredientName).png" }
    
    public var ingredientName: String
}
