//
//  APIRequestTests.swift
//  CookbookTests
//
//  Created by Daniil Kostitsin on 09.09.2021.
//

import XCTest
@testable import Cookbook

class APIRequestTests: XCTestCase {
    func testShouldCreateMealsByNameRequestWithValidName() {
        XCTAssertNotNil(MealsByNameRequest(mealName: "pasta"))
    }
    
    func testShouldNotCreateMealsByNameRequestWithEmptyName() {
        XCTAssertNil(MealsByNameRequest(mealName: ""))
    }
    
    func testShouldCreateProperURLForSearchByName() {
        let mealsByNameRequest = MealsByNameRequest(mealName: "tofu")
        
        guard let mealsByNameRequest = mealsByNameRequest else {
            XCTFail("Unable to create network request")
            return
        }
        
        XCTAssertEqual(mealsByNameRequest.request.url, URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=tofu"))
    }
    
    
    func testShouldCreateMealsByIDRequestWithValidID() {
        XCTAssertNotNil(MealByIDRequest(mealID: "213"))
    }
    
    func testShouldNotCreateMealsByIDRequestWithInvalidID() {
        XCTAssertNil(MealByIDRequest(mealID: "notANumber"))
    }
    
   
    func testShouldCreateProperURLForLookupByID() {
        let mealByIDRequest = MealByIDRequest(mealID: "52772")
        
        guard let mealByIDRequest = mealByIDRequest else {
            XCTFail("Unable to create network request")
            return
        }
        
        XCTAssertEqual(mealByIDRequest.request.url, URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=52772"))
    }
}
