//
//  CategoryListResponse.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 09.09.2021.
//

import Foundation

/// Stores all available category names
public struct CategoryListResponse {
    public var categoryInfos: [CategoryInfo]
}

extension CategoryListResponse: Decodable {
    public enum CodingKeys: String, CodingKey {
        case categoryInfos = "categories"
    }
}
