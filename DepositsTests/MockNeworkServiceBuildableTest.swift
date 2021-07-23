//
//  MockNeworkServiceBuildableTest.swift
//  DepositsTests
//
//  Created by Sayooj Krishnan  on 23/07/21.
//

@testable import Deposits
import XCTest
import Combine

class MockNetworkServiceTest : XCTestCase {
    
    var sut : MockNeworkServiceBuildable!

    override func setUpWithError() throws {
       sut = MockNeworkService()
    }

    override func tearDownWithError() throws {
       sut = nil
    }

    
    func test_MockNetworkServiceWhenMockEnvIsSupplied_ShouldBuildMockURLSession() {
        sut.mockType = .mockData(Data())
        let session = sut.client.session as? MockURLSession
        XCTAssertNotNil(session)
    }
    
    func test_MockNetworkServiceWhenMockDataIsSupplied_ShouldBuildSessionWithSuppliedData() {
        let data = Data(count: 1)
        sut.mockType = .mockData(data)
        let session = sut.client.session as! MockURLSession
        XCTAssertEqual(session.nextData, data)
    }
    
    func test_MockNetworkServiceWhenMockJSONIsSupplied_ShouldBuildSessionWithSupplieJSON() {
        
        sut.mockType = .localJSON("deposits_list")
        let session = sut.client.session as! MockURLSession
        XCTAssertNotNil(session.nextData)
        
        let json = try? JSONDecoder().decode([DepositModel].self, from: session.nextData)
        XCTAssertNotNil(json)
    }
    
    
}


