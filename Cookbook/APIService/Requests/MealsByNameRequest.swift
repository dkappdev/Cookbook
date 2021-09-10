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
    
    public private(set) var mealName: String
}
