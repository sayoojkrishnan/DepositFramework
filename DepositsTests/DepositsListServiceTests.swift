//
//  DepositsListService.swift
//  DepositsTests
//
//  Created by Sayooj Krishnan  on 21/07/21.
//
@testable import Deposits
import XCTest
import Combine

class DepositsListServiceTests : XCTestCase {

    var sut : DepositListsService!
    override func setUpWithError() throws {
        // Forcing to switch to mock env
        _ = DepositsModule.build(withEnv: .mock)
        sut = DepositListsService()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    

    var depoisitListCancellable : AnyCancellable?
    func testDepositsListServicew_WhenDepositListIsRequestedInMockEnv_ShouldProvideListOfDepositLoadedFromLocal() {
        
        var loadStatus : Bool = false
        var deposits : [DepositModel] = []
        let expectation = expectation(description: "depositlist expectation")
        depoisitListCancellable = sut.fetchDeposits(pageSize: 1, offset: 5)
            .sink(receiveCompletion: { state in
                switch state {
                case .failure(_) :
                    loadStatus = false
                    expectation.fulfill()
                case .finished :
                    loadStatus = true
                }
            }, receiveValue: { dp in
                deposits = dp
                loadStatus = true
                expectation.fulfill()
            })
       
        waitForExpectations(timeout: 0.6, handler: nil)
        
        XCTAssertTrue(loadStatus)
        XCTAssertEqual(deposits.count, 18)
    }
   

}
