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
    func testShouldDecodeValidMealsByNameRequestData() {
        let expectation = expectation(description: "Should decode meal info list")
        
        var fullMealInfoList: MealsByNameResponse? = nil
        
        let mealsByNameRequest = MealsByNameRequest(mealName: "pasta")
        
        guard let mealsByNameRequest = mealsByNameRequest else {
            XCTFail("Unable to create network request")
            return
        }
        
        mealsByNameRequest.send { result in
            switch result {
            case .success(let mealInfoList):
                fullMealInfoList = mealInfoList
                expectation.fulfill()
            case .failure(_):
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 15, handler: nil)
        
        XCTAssertNotNil(fullMealInfoList)
    }
}
