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
    var dummyModel : DepositModel!
    override func setUpWithError() throws {
       
        dummyModel = DepositModel(id: UUID().uuidString, date: 1626868205033, chequeAmount: 100, description: "Test", checkFrontImage: nil, checkBackImage: nil)
        sut = DepositViewModel(deposit: dummyModel)
    }

    override func tearDownWithError() throws {
        sut = nil
        dummyModel = nil
    }

    func testDespositViewModel_whenInitWithDepositModel_ShouldProvideValidDateAndAmount() {
        XCTAssertEqual(sut.date, "21-07-2021", "Added date formatting is incorrect")
        XCTAssertEqual(sut.amountString, "$100.00", "Cheque amount formatting is incorrect ")
        XCTAssertEqual(sut.description, dummyModel.description)
        XCTAssertEqual(sut.id, dummyModel.id)
        XCTAssertEqual(sut.addedDate, dummyModel.addedDate)
        // Temp test
        XCTAssertEqual(sut.chequeFrontImage, nil)
        XCTAssertEqual(sut.chequeBackImage, nil)
    }

}
