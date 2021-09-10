//
//  CategoryListRequest.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 09.09.2021.
//

import Foundation

/// Request for getting all available categories in TheMealDB
public struct CategoryListRequest: APIRequest {
    public typealias Response = CategoryListResponse
    
    public var path: String { "/api/json/v1/1/categories.php" }
}
