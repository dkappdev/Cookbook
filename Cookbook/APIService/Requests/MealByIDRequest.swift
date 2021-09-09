//
//  MealByIDRequest.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 09.09.2021.
//

import Foundation

/// Request for getting a meal by its ID
public struct MealByIDRequest: APIRequest {
    public typealias Response = MealByIDResponse
    
    public var path: String { "/api/json/v1/1/lookup.php" }
    
    public var queryItems: [URLQueryItem]? { [URLQueryItem(name: "i", value: mealID)] }
    
    public var mealID: String
    
    /// Creates a request to lookup a meal by ID
    /// - Parameter mealID: the meal ID as a string, the string should contain an integer
    public init?(mealID: String) {
        guard Int(mealID) != nil else {
            return nil
        }
        
        self.mealID = mealID
    }
}
