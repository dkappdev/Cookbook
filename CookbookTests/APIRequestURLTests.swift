//
//  APIRequestURLTests.swift
//  CookbookTests
//
//  Created by Daniil Kostitsin on 09.09.2021.
//

import XCTest
@testable import Cookbook

class APIRequestURLTests: XCTestCase {
    func testShouldCreateProperURLForSearchByName() {
        let mealsByNameRequest = MealsByNameRequest(mealName: "tofu")
        
        XCTAssertEqual(mealsByNameRequest.request.url, URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=tofu"))
    }
}
