//
//  CookbookTests.swift
//  CookbookTests
//
//  Created by Daniil Kostitsin on 09.09.2021.
//

import XCTest
@testable import Cookbook

class ServerResponseDecodingTests: XCTestCase {
    
    /// Makes sure that server responses can be properly decoded into instances
    func testShouldDecodeValidMealsByNameRequestData() {
        let mealsByNameRequest = MealsByNameRequest(mealName: "pasta")
        
        let expectation = expectation(description: "Should decode meal info list")
        
        var fullMealInfoList: FullMealInfoList? = nil
        
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
