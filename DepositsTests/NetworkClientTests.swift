//
//  NetworkClientTests.swift
//  DepositsTests
//
//  Created by Sayooj Krishnan  on 23/07/21.
//
@testable import Deposits
import XCTest
import Combine

class NetworkClientTests: XCTestCase {
    
    var sutCancellable :AnyCancellable?
    
    var sut : NetworkClient!
    var session : MockURLSession!
    override func setUpWithError() throws {
        session = MockURLSession()
        sut = NetworkClient(session: session)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        session = nil
    }
    
    
    func testNetworkClient_WhenInitWithDummySession() {
        
        struct Mock : Decodable {
            let status : Int
        }
        
        let  res =  """
                { "status" : 1  }
        """.data(using: .utf8)!
        
        var loadStatus : Bool = false
        var mockResponse  : Mock!
        var error : NetworkClientError?
        let expectation = expectation(description: "depositlist expectation")
        session.nextData = res
        
        let service = MockService(params : [:])
        sutCancellable = sut.request(type: Mock.self, serviceRequest: service)
            .sink(receiveCompletion: { res in
                switch res {
                case .finished:
                    loadStatus = true
                case .failure(let e ) :
                    loadStatus = false
                    error = e
                    expectation.fulfill()
                }
            }, receiveValue: { data in
                loadStatus = true
                mockResponse = data
                expectation.fulfill()
            })
        
        
        waitForExpectations(timeout: 0.4, handler: nil)
        
        XCTAssertTrue(loadStatus)
        XCTAssertEqual(mockResponse.status, 1)
        XCTAssertNil(error)
        
    }
    
}
