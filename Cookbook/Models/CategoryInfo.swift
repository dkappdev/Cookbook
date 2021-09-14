//
//  CategoryInfo.swift
//  Cookbook
//
//  Created by Daniil Kostitsin on 10.09.2021.
//

import Foundation

/// A type that represents detailed information about a meal category
public struct CategoryInfo {
    public var categoryName: String
    public var categoryDescription: String
    public var imageURL: URL
}

extension CategoryInfo: Decodable {
    public enum CodingKeys: String, CodingKey {
        case categoryName = "strCategory"
        case categoryDescription = "strCategoryDescription"
        case imageURL = "strCategoryThumb"
    }
}

extension CategoryInfo: Hashable {
    public static func == (lhs: CategoryInfo, rhs: CategoryInfo) -> Bool {
        lhs.categoryName == rhs.categoryName
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(categoryName)
    }
}
