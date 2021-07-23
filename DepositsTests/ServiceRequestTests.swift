//
//  ServiceRequestTests.swift
//  DepositsTests
//
//  Created by Sayooj Krishnan  on 23/07/21.
//

import XCTest
@testable import Deposits

class ServiceRequestTests: XCTestCase {
    
    var sut :  ServiceRequest!

    override func setUpWithError() throws {
       sut = MockService(params: ["item":"test"])
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testServiceRequest_WhenServiceInitWithParams_ShouldReturnValidURL() {
        XCTAssertEqual(sut.endPoint.absoluteString, "https://test.com:443/api/test?item=test")
    }
   

}

