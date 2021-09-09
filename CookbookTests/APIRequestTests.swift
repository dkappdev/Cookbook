//
//  APIRequestTests.swift
//  CookbookTests
//
//  Created by Daniil Kostitsin on 09.09.2021.
//

import XCTest
@testable import Cookbook

class APIRequestTests: XCTestCase {
    static let validMealName = "pasta"
    static let validMealID = "52772"
    
    func testShouldCreateMealsByNameRequestWithValidName() {
        XCTAssertNotNil(MealsByNameRequest(mealName: Self.validMealName))
    }
    
    func testShouldNotCreateMealsByNameRequestWithEmptyName() {
        XCTAssertNil(MealsByNameRequest(mealName: ""))
    }
    
    func testShouldCreateProperURLForMealsByNameRequest() {
        let mealsByNameRequest = MealsByNameRequest(mealName: Self.validMealName)
        
        guard let mealsByNameRequest = mealsByNameRequest else {
            XCTFail("Unable to create network request")
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
            XCTFail("Unable to create network request")
            return
        }
        
        XCTAssertEqual(mealByIDRequest.request.url, URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=52772"))
    }
    
    func testShouldCreateProperURLForCategoryListRequest() {
        let categoryListRequest = CategoryListRequest()
        
        XCTAssertEqual(categoryListRequest.request.url, URL(string: "https://www.themealdb.com/api/json/v1/1/list.php?c=list"))
    }
}
