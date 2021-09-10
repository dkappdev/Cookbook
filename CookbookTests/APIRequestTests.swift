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
    static let validIngredient = "lime"
    
    func testShouldCreateProperURLForMealsByNameRequest() {
        let mealsByNameRequest = MealsByNameRequest(mealName: Self.validMealName)
        
        XCTAssertEqual(mealsByNameRequest.request.url, URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=pasta"))
    }
   
    func testShouldCreateProperURLForMealByIDRequest() {
        let mealByIDRequest = MealByIDRequest(mealID: Self.validMealID)
        
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
    
    func testShouldCreateProperURLForMealsByCategoryRequest() {
        let mealsByCategoryRequest = MealsByCategoryRequest(category: Self.validCategory)
    
        XCTAssertEqual(mealsByCategoryRequest.request.url, URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=seafood"))
    }
    
    func testShouldCreateProperURLForRandomMealRequest() {
        let randomMealRequest = RandomMealRequest()
        
        XCTAssertEqual(randomMealRequest.request.url, URL(string: "https://www.themealdb.com/api/json/v1/1/random.php"))
    }
    
    func testShouldCreateProperURLForMealsByAreaRequest() {
        let mealsByAreaRequest = MealsByAreaRequest(areaName: Self.validArea)
        
        XCTAssertEqual(mealsByAreaRequest.request.url, URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?a=canadian"))
    }
    
    func testShouldCreateProperURLForIngredientImageRequest() {
        let ingredientImageRequest = IngredientImageRequest(ingredientName: Self.validIngredient)
        
        XCTAssertEqual(ingredientImageRequest.request.url, URL(string: "https://www.themealdb.com/images/ingredients/lime.png"))
    }
    
    func testShouldPreserveURLForArbitraryImageRequest() {
        let imageURL = URL(string: "https://www.themealdb.com/images/media/meals/ustsqw1468250014.jpg")
        
        guard let imageURL = imageURL else {
            XCTFail("Failed to create URL from string")
            return
        }
        
        let arbitraryImageRequest = ArbitraryImageRequest(imageURL: imageURL)
        
        XCTAssertEqual(arbitraryImageRequest.request.url, imageURL)
    }
}
