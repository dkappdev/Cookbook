//
//  APIRequestTests.swift
//  CookbookTests
//
//  Created by Daniil Kostitsin on 09.09.2021.
//

import XCTest
@testable import Cookbook

class APIRequestTests: XCTestCase {
    
    // Note: used in other tests
    static let validMealName = "pasta"
    static let validMealID = "52772"
    static let validCategory = "seafood"
    static let validArea = "canadian"
    
    func testShouldCreateMealsByNameRequestWithValidName() {
        XCTAssertNotNil(MealsByNameRequest(mealName: Self.validMealName))
    }
    
    func testShouldNotCreateMealsByNameRequestWithEmptyName() {
        XCTAssertNil(MealsByNameRequest(mealName: ""))
    }
    
    func testShouldCreateProperURLForMealsByNameRequest() {
        let mealsByNameRequest = MealsByNameRequest(mealName: Self.validMealName)
        
        guard let mealsByNameRequest = mealsByNameRequest else {
            XCTFail("Failed to create network request")
            return
        }
        
        XCTAssertEqual(mealsByNameRequest.request.url, URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=pasta"))
    }
    
    
    func testShouldCreateMealsByIDRequestWithValidID() {
        XCTAssertNotNil(MealByIDRequest(mealID: Self.validMealID))
    }
    
    func testShouldNotCreateMealsByIDRequestWithInvalidID() {
        XCTAssertNil(MealByIDRequest(mealID: "notANumber"))
    }
    
   
    func testShouldCreateProperURLForMealByIDRequest() {
        let mealByIDRequest = MealByIDRequest(mealID: Self.validMealID)
        
        guard let mealByIDRequest = mealByIDRequest else {
            XCTFail("Failed to create network request")
            return
        }
        
        XCTAssertEqual(mealByIDRequest.request.url, URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=52772"))
    }
    
    func testShouldCreateProperURLForCategoryListRequest() {
        let categoryListRequest = CategoryListRequest()
        
        XCTAssertEqual(categoryListRequest.request.url, URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php"))
    }
    
    func testShouldCreateProperURLForAreaListRequest() {
        let areaListRequest = AreaListRequest()
        
        XCTAssertEqual(areaListRequest.request.url, URL(string: "https://www.themealdb.com/api/json/v1/1/list.php?a=list"))
    }
    
    func testShouldCreateProperURLForIngredientListRequest() {
        let ingredientListRequest = IngredientListRequest()
        
        XCTAssertEqual(ingredientListRequest.request.url, URL(string: "https://www.themealdb.com/api/json/v1/1/list.php?i=list"))
    }
    
    func testShouldCreateMealsByCategoryRequestWithValidCategory() {
        XCTAssertNotNil(MealsByCategoryRequest(category: Self.validCategory))
    }
    
    func testShouldNotCreateMealsByCategoryRequestWithInvalidCategory() {
        XCTAssertNil(MealsByCategoryRequest(category: ""))
    }
    
    func testShouldCreateProperURLForMealsByCategoryRequest() {
        let mealsByCategoryRequest = MealsByCategoryRequest(category: Self.validCategory)
        
        guard let mealsByCategoryRequest = mealsByCategoryRequest else {
            XCTFail("Failed to create network request")
            return
        }
        
        XCTAssertEqual(mealsByCategoryRequest.request.url, URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=seafood"))
    }
    
    func testShouldCreateProperURLForRandomMealRequest() {
        let randomMealRequest = RandomMealRequest()
        
        XCTAssertEqual(randomMealRequest.request.url, URL(string: "https://www.themealdb.com/api/json/v1/1/random.php"))
    }
    
    func testShouldCreateMealsByAreaRequestWithValidArea() {
        XCTAssertNotNil(MealsByAreaRequest(areaName: Self.validArea))
    }
    
    func testShouldNotCreateMealsByAreaRequestWithInvalidArea() {
        XCTAssertNil(MealsByAreaRequest(areaName: ""))
    }
    
    func testShouldCreateProperURLForMealsByAreaRequest() {
        let mealsByAreaRequest = MealsByAreaRequest(areaName: Self.validArea)
        
        guard let mealsByAreaRequest = mealsByAreaRequest else {
            XCTFail("Failed to create network request")
            return
        }
        
        XCTAssertEqual(mealsByAreaRequest.request.url, URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?a=canadian"))
    }
}
