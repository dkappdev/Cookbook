//
//  CodableTests.swift
//  CookbookTests
//
//  Created by Daniil Kostitsin on 27.09.2021.
//

import XCTest
@testable import Cookbook

class CodableTests: XCTestCase {
    
    func compareFullMealInfos(_ lhs: FullMealInfo, _ rhs: FullMealInfo) -> Bool {
        return lhs.mealID == rhs.mealID && lhs.mealName == rhs.mealName && lhs.category == rhs.category && lhs.areaInfo.name == rhs.areaInfo.name && lhs.cookingInstructions == rhs.cookingInstructions && lhs.imageURL == rhs.imageURL && lhs.youtubeURL == rhs.youtubeURL && lhs.ingredients == rhs.ingredients
    }

    func testShouldProperlyEncodeFullMealInfoWithZeroIngredients() {
        let mealInfo = FullMealInfo(mealID: "1235", mealName: "Meal name", category: "Category", areaInfo: AreaInfo(name: "Unknown"), cookingInstructions: "Cooking instructions", imageURL: URL(string: "https://example.org")!, youtubeURL: URL(string: ""), ingredients: [])
        
        let encodedData = try! JSONEncoder().encode(mealInfo)
        
        let decodedInfo = try! JSONDecoder().decode(FullMealInfo.self, from: encodedData)
        
        XCTAssertTrue(compareFullMealInfos(mealInfo, decodedInfo))
    }
    
    func testShouldProperlyEncodeFullMealInfoWithLessThan20Ingredients() {
        var ingredients: [IngredientAmount] = []
        
        for i in 0..<5 {
            ingredients.append(IngredientAmount(name: "Name\(i)", amount: "Amount\(i)"))
        }
        
        let mealInfo = FullMealInfo(mealID: "1235", mealName: "Meal name", category: "Category", areaInfo: AreaInfo(name: "Unknown"), cookingInstructions: "Cooking instructions", imageURL: URL(string: "https://example.org")!, youtubeURL: URL(string: ""), ingredients: ingredients)
        
        let encodedData = try! JSONEncoder().encode(mealInfo)
        
        let decodedInfo = try! JSONDecoder().decode(FullMealInfo.self, from: encodedData)
        
        XCTAssertTrue(compareFullMealInfos(mealInfo, decodedInfo))
    }
    
    func testShouldProperlyEncodeFullMealInfoWith20Ingredients() {
        var ingredients: [IngredientAmount] = []
        
        for i in 0..<20 {
            ingredients.append(IngredientAmount(name: "Name\(i)", amount: "Amount\(i)"))
        }
        
        let mealInfo = FullMealInfo(mealID: "1235", mealName: "Meal name", category: "Category", areaInfo: AreaInfo(name: "Unknown"), cookingInstructions: "Cooking instructions", imageURL: URL(string: "https://example.org")!, youtubeURL: URL(string: ""), ingredients: ingredients)
        
        let encodedData = try! JSONEncoder().encode(mealInfo)
        
        let decodedInfo = try! JSONDecoder().decode(FullMealInfo.self, from: encodedData)
        
        XCTAssertTrue(compareFullMealInfos(mealInfo, decodedInfo))
    }
}
