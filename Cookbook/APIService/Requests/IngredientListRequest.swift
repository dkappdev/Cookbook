//
//  IngredientListRequest.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 10.09.2021.
//

import Foundation

public struct IngredientListRequest: APIRequest {
    public typealias Response = IngredientListResponse
    
    public var path: String { "/api/json/v1/1/list.php" }
    
    public var queryItems: [URLQueryItem]? { [URLQueryItem(name: "i", value: "list")] }
}
