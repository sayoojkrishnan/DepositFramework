//
//  DepositChequeService.swift
//  DepositsTests
//
//  Created by Sayooj Krishnan  on 23/07/21.
//

@testable import Deposits
import XCTest
import Combine

class DepositChequeServiceTests: XCTestCase {
    
    var sut : DepositChequeService!

    override func setUpWithError() throws {
        _ = DepositsEnv.build(withEnv: .mock)
       sut = DepositChequeService()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    var depositCancellable : AnyCancellable?
    func test_DepositChequeService_whenSaveDepositCalledOnMockEnv_ShouldReturnMockedResponse() {
        let date = Date().timeIntervalSince1970 * 1000
        let params : [String:Any] = [
            "depositAmount" : 100.0,
            "depositDate":  date ,
            "created" : date,
            "depositDescription" : "chequeDescription"
        ]
        
        var loadStatus : Bool = false
        var deposit : DepositModel!
        let expectation = expectation(description: "depositlist expectation")
        depositCancellable = sut.depositCheuqe(param: params)
            .sink(receiveCompletion: { state in
                switch state {
                case .failure(_) :
                    loadStatus = false
                    expectation.fulfill()
                case .finished :
                    loadStatus = true
                }
            }, receiveValue: {
                deposit = $0
                loadStatus = true
                expectation.fulfill()
            })
        waitForExpectations(timeout: 0.6, handler: nil)
        
        XCTAssertTrue(loadStatus)
        XCTAssertEqual(deposit.amount, 100.0)
        XCTAssertEqual(deposit.description, "chequeDescription")
        XCTAssertEqual(deposit.date,date)
        
    }

}
