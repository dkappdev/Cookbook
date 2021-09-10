//
//  ServerResponseDecodingTests.swift
//  ServerResponseDecodingTests
//
//  Created by Daniil Kostitsin on 09.09.2021.
//

import XCTest
@testable import Cookbook

class ServerResponseDecodingTests: XCTestCase {
    
    func genericTestDecode<RequestType, ResponseType>(withRequest request: RequestType?) where RequestType: APIRequest, RequestType.Response == ResponseType, RequestType.Response: Decodable {
        
        let expectation = expectation(description: "Should finish network request")
        
        guard let request = request else {
            XCTFail("Unable to create network request")
            return
        }
        
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
}
