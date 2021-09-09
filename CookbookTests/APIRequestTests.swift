//
//  APIRequestTests.swift
//  CookbookTests
//
//  Created by Daniil Kostitsin on 09.09.2021.
//

import XCTest
@testable import Cookbook

class APIRequestTests: XCTestCase {
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
}
