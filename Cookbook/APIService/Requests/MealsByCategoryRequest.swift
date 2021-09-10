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
    
    /// Creates a request to get all meals from a category
    /// - Parameter category: the category of meals
    public init?(category: String) {
        guard !category.isEmpty else {
            return nil
        }
        
        self.category = category
    }
}
