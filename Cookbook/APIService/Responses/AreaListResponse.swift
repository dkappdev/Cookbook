//
//  AreaListResponse.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 10.09.2021.
//

import Foundation

/// Stores all available area names
public struct AreaListResponse {
    public var areaInfos: [AreaInfo]
}

extension AreaListResponse: Decodable {
    public enum CodingKeys: String, CodingKey {
        case areaInfos = "meals"
    }
}
