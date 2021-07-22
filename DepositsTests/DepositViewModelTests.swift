//
//  DepositViewModelTests.swift
//  DepositsTests
//
//  Created by Sayooj Krishnan  on 21/07/21.
//

@testable import Deposits
import XCTest


class DepositViewModelTests: XCTestCase {
    
    var sut : DepositViewModel!

    override func setUpWithError() throws {
       
        let dummyModel = DepositModel(id: UUID().uuidString, date: 1626868205033, chequeAmount: 100, description: "Test", checkFrontImage: nil, checkBackImage: nil)
        sut = DepositViewModel(deposit: dummyModel)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testDespositViewModel_whenInitWithDepositModel_ShouldProvideValidDateAndAmount() {
        XCTAssertEqual(sut.date, "21-07-2021", "Added date formatting is incorrect")
        XCTAssertEqual(sut.amount, "$100.00", "Cheque amount formatting is incorrect ")
    }

}
