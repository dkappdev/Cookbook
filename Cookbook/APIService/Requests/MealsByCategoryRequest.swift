//
//  MealsByCategoryRequest.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 10.09.2021.
//

import Foundation

/// Request for getting all meals from a category
public struct MealsByCategoryRequest: APIRequest {
    public typealias Response = MealsByCategoryResponse
    
    public var path: String { "/api/json/v1/1/filter.php" }
    
    public var queryItems: [URLQueryItem]? { [URLQueryItem(name: "c", value: category)] }
    
    public private(set) var category: String
}
