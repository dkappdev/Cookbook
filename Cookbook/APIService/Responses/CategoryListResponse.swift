//
//  CategoryListResponse.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 09.09.2021.
//

import Foundation

/// Stores all available category names
public struct CategoryListResponse {
    public var categoryNames: [String]
    
    private struct NestedCategory: Decodable {
        public var categoryName: String
        
        enum CodingKeys: String, CodingKey {
            case categoryName = "strCategory"
        }
    }
}

extension CategoryListResponse: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AnyCodingKey.self)
        
        let nestedCategories = try values.decode([NestedCategory].self, forKey: AnyCodingKey(stringValue: "meals"))
        
        categoryNames = []
        
        for category in nestedCategories {
            categoryNames.append(category.categoryName)
        }
    }
}
