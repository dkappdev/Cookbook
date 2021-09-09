//
//  MealByNameRequest.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 09.09.2021.
//

import Foundation

/// Request for getting all meals that match specified name
public struct MealsByNameRequest: APIRequest {
    public typealias Response = MealsByNameResponse
    
    public var path: String { "/api/json/v1/1/search.php" }
    
    public var queryItems: [URLQueryItem]? { [URLQueryItem(name: "s", value: mealName)] }
    
    public var mealName: String
    
    /// Creates a request to search meals by name
    /// - Parameter mealName: the meal name, this string should not be empty
    public init?(mealName: String) {
        guard !mealName.isEmpty else {
            return nil
        }
        
        self.mealName = mealName
    }
}
