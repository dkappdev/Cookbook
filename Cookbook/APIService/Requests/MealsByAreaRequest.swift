//
//  MealsByAreaRequest.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 10.09.2021.
//

import Foundation

/// Request for getting al meals from an area
public struct MealsByAreaRequest: APIRequest {
    public typealias Response = MealsByAreaResponse
    
    public var path: String { "/api/json/v1/1/filter.php" }
    
    public var queryItems: [URLQueryItem]? { [URLQueryItem(name: "a", value: areaName)] }
    
    public private(set) var areaName: String
    
    /// Creates a request to get all meals from an area
    /// - Parameter areaName: the origin area of meal
    public init?(areaName: String) {
        guard !areaName.isEmpty else {
            return nil
        }
        
        self.areaName = areaName
    }
}
