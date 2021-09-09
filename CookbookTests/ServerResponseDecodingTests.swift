//
//  ServerResponseDecodingTests.swift
//  ServerResponseDecodingTests
//
//  Created by Daniil Kostitsin on 09.09.2021.
//

import XCTest
@testable import Cookbook

class ServerResponseDecodingTests: XCTestCase {
    
    /// Makes sure that server responses can be properly decoded into instances
    func testShouldDecodeValidMealsByNameResponse() {
        let expectation = expectation(description: "Should finish network request")
        
        var mealsByNameResponse: MealsByNameResponse? = nil
        
        let mealsByNameRequest = MealsByNameRequest(mealName: "pasta")
        
        guard let mealsByNameRequest = mealsByNameRequest else {
            XCTFail("Unable to create network request")
            return
        }
        
        mealsByNameRequest.send { result in
            switch result {
            case .success(let response):
                mealsByNameResponse = response
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 15, handler: nil)
        
        XCTAssertNotNil(mealsByNameResponse)
    }
    
    func testShouldDecodeValidMealByIDResponse() {
        let expectation = expectation(description: "Should finish network request")
        
        var mealByIDResponse: MealByIDResponse? = nil
        
        let mealByIDRequest = MealByIDRequest(mealID: "52772")
        
        guard let mealByIDRequest = mealByIDRequest else {
            XCTFail("Unable to create network request")
            return
        }
        
        mealByIDRequest.send { result in
            switch result {
            case .success(let response):
                mealByIDResponse = response
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 15, handler: nil)
        
        XCTAssertNotNil(mealByIDResponse)
    }
}
