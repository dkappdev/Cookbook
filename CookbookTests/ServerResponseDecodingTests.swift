//
//  ServerResponseDecodingTests.swift
//  ServerResponseDecodingTests
//
//  Created by Daniil Kostitsin on 09.09.2021.
//

import XCTest
@testable import Cookbook

class ServerResponseDecodingTests: XCTestCase {
    
    func genericTestDecode<RequestType, ResponseType>(withRequest request: RequestType?, completion: @escaping (ResponseType?) -> Void) where RequestType: APIRequest, RequestType.Response == ResponseType, RequestType.Response: Decodable {
        
        let expectation = expectation(description: "Should finish network request")
        
        guard let request = request else {
            XCTFail("Unable to create network request")
            return
        }
        
        request.send { result in
            switch result {
            case .success(let networkResponse):
                completion(networkResponse)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
            expectation.fulfill()
        }
    }
    
    /// Makes sure that server responses can be properly decoded into instances
    func testShouldDecodeValidMealsByNameResponse() {
        genericTestDecode(withRequest: MealsByNameRequest(mealName: APIRequestTests.validMealName)) { response in
            XCTAssertNotNil(response)
        }
        
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testShouldDecodeValidMealByIDResponse() {
        genericTestDecode(withRequest: MealByIDRequest(mealID: APIRequestTests.validMealID)) { response in
            XCTAssertNotNil(response)
        }
        
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testShouldDecodeValidCategoryListResponse() {
        genericTestDecode(withRequest: CategoryListRequest()) { response in
            XCTAssertNotNil(response)
        }
        
        waitForExpectations(timeout: 15, handler: nil)
    }
}
