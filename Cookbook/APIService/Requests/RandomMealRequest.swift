//
//  RandomMealRequest.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 10.09.2021.
//

import Foundation

public struct RandomMealRequest: APIRequest {
    public typealias Response = RandomMealResponse
    
    public var path: String { "/api/json/v1/1/random.php" }
}
