//
//  AreaListRequest.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 10.09.2021.
//

import Foundation

/// Request for getting all available meal areas in TheMealDB
public struct AreaListRequest: APIRequest {
    public typealias Response = AreaListResponse
    
    public var path: String { "/api/json/v1/1/list.php" }
    
    public var queryItems: [URLQueryItem]? { [URLQueryItem(name: "a", value: "list")] }
}
