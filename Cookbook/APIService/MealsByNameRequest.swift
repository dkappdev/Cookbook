//
//  MealByNameRequest.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 09.09.2021.
//

import Foundation

public struct MealsByNameRequest: APIRequest {
    public typealias Response = FullMealInfoList
    
    public var mealName: String
    
    public var path: String { "/api/json/v1/1/search.php" }
    
    public var queryItems: [URLQueryItem]? { [URLQueryItem(name: "s", value: mealName)] }
}
