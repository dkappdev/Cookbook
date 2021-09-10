//
//  ServerResponseDecodingTests.swift
//  ServerResponseDecodingTests
//
//  Created by Daniil Kostitsin on 09.09.2021.
//

import XCTest
@testable import Cookbook

class ServerResponseDecodingTests: XCTestCase {
    
    func genericTestDecode<RequestType, ResponseType>(withRequest request: RequestType) where RequestType: APIRequest, RequestType.Response == ResponseType, RequestType.Response: Decodable {
        
        let expectation = expectation(description: "Should finish network request")
        
        request.send { result in
            switch result {
            case .success(let response):
                print(response)
                XCTAssertNotNil(response)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
     
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func genericTestDecodeImage<RequestType>(withRequest request: RequestType) where RequestType: APIRequest, RequestType.Response == UIImage {
        
        let expectation = expectation(description: "Should finish network request")
        
        request.send { result in
            switch result {
            case .success(let response):
                print(response)
                XCTAssertNotNil(response)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    /// Makes sure that server responses can be properly decoded into instances
    func testShouldDecodeValidMealsByNameResponse() {
        genericTestDecode(withRequest: MealsByNameRequest(mealName: APIRequestTests.validMealName))
    }
    
    func testShouldDecodeValidMealByIDResponse() {
        genericTestDecode(withRequest: MealByIDRequest(mealID: APIRequestTests.validMealID))
    }
    
    func testShouldDecodeValidCategoryListResponse() {
        genericTestDecode(withRequest: CategoryListRequest())
    }
    
    func testShouldDecodeValidAreaListResponse() {
        genericTestDecode(withRequest: AreaListRequest())
    }
    
    func testShouldDecodeValidIngredientListResponse() {
        genericTestDecode(withRequest: IngredientListRequest())
    }
    
    func testShouldDecodeValidMealsByCategoryResponse() {
        genericTestDecode(withRequest: MealsByCategoryRequest(category: APIRequestTests.validCategory))
    }
    
    func testShouldDecodeValidRandomMealResponse() {
        genericTestDecode(withRequest: RandomMealRequest())
    }
    
    func testShouldDecodeValidMealsByAreaResponse() {
        genericTestDecode(withRequest: MealsByAreaRequest(areaName: APIRequestTests.validArea))
    }
    
    func testShouldDecodeValidIngredientImageResponse() {
        genericTestDecodeImage(withRequest: IngredientImageRequest(ingredientName: APIRequestTests.validIngredient))
    }
    
    func testShouldDecodeValidArbitraryImageResponse() {
        let imageURL = URL(string: "https://www.themealdb.com/images/media/meals/ustsqw1468250014.jpg")
        
        guard let imageURL = imageURL else {
            XCTFail("Failed to create URL from string")
            return
        }
        
        genericTestDecodeImage(withRequest: ArbitraryImageRequest(imageURL: imageURL))
    }
}
