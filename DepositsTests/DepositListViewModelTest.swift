//
//  DepositListViewModelTest.swift
//  DepositsTests
//
//  Created by Sayooj Krishnan  on 26/07/21.
//

@testable import Deposits
import XCTest
import Combine

class DepositListViewModelTest: XCTestCase {
    
    var sut : DepositsListViewModel!
    var mockService : MockDepositsListService!
    
    override func setUpWithError() throws {
        mockService = MockDepositsListService()
        sut = DepositsListViewModel(service: mockService)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockService = nil
    }
    
    
    func testDepositListViewModel_WhenfetchDepositsCalledWithDummySuccess_ShouldReturnProvidedDummyData() {
        // When fetch deposit called with 3 dummy data
        // ViewModel Should call the service class for data
        // Should update total and number of transaction
        mockService.reponse = [DepositModel.dummy,DepositModel.dummy,DepositModel.dummy]
        sut.initialFetch()
        
        let exp = expectation(description: "depositListFetchExpectation")
        let res = XCTWaiter.wait(for: [exp], timeout: 0.4)
        
        
        guard res == .timedOut else {
            XCTFail("Waiting failed!")
            return
        }
        
        XCTAssertTrue(mockService.hasCalledFetchDeposits)
        XCTAssertEqual(sut.deposits.count,3)
        XCTAssertTrue(sut.viewState! == .success)
        // the dummy object has $100  
        XCTAssertEqual(sut.totalDeposits, "$300.00")
        XCTAssertEqual(sut.numberOfTransaction, "from 3 transactions")
    }
    
    
    func testDepositListViewModel_WhenNewDepositAdded_ShouldReflectTheList() {
        // when new deposit added
        // Should reflect the new deposit in the list
        // should update total and number of transactions
        
        mockService.reponse = [DepositModel.dummy,DepositModel.dummy,DepositModel.dummy]
        sut.initialFetch()
        
        let exp = expectation(description: "depositListFetchExpectation")
        let res = XCTWaiter.wait(for: [exp], timeout: 0.4)
        guard res == .timedOut else { XCTFail("Waiting failed!") ; return}
        
        let deposit = DepositModel.dummy
        sut.deposit(deposit: deposit)
        XCTAssertEqual(sut.deposits.count,4)
        XCTAssertEqual(sut.totalDeposits, "$400.00")
        XCTAssertEqual(sut.numberOfTransaction, "from 4 transactions")
        
    }
    
    
    func testDepositListViewModel_WhenPaginateRequested_ShouldGetNewSetOfDataAndUpdateOffset() {
        
        let dummy = DepositModel.dummy
        let list = [dummy,dummy,dummy]
        
        mockService.reponse = list
        
        try? sut.paginate()
        
        let exp = expectation(description: "depositListFetchExpectation")
        let res = XCTWaiter.wait(for: [exp], timeout: 0.4)
        guard res == .timedOut else { XCTFail("Waiting failed!") ; return}
        
        // offset initally set to 0
        //should update to current value +  number of item received in the call
        XCTAssertEqual(sut.offset, 3)
        XCTAssertEqual(sut.hasMoreData, true)
    }
    
    func testDepositListViewModel_WhenPaginateRequestFinishWithNoData_ShouldGSethasMoreDatatToFalse() {
        
        mockService.reponse  = []
        try? sut.paginate()
       
        let exp = expectation(description: "depositListFetchExpectation")
        let res = XCTWaiter.wait(for: [exp], timeout: 0.4)
        guard res == .timedOut else { XCTFail("Waiting failed!") ; return}
        
        XCTAssertEqual(sut.hasMoreData, false)
        XCTAssertEqual(sut.offset, 0)
    }
    
    func testDepositListViewModel_PaginationRequestWhenhasMoreDataIsFalse_ShouldThorwError() {
        
        // Pagination requested , server respond with []
        // Should throw if paginate called again
        mockService.reponse  = []
        try? sut.paginate()
        
        let exp = expectation(description: "depositListFetchExpectation")
        let res = XCTWaiter.wait(for: [exp], timeout: 0.4)
        guard res == .timedOut else { XCTFail("Waiting failed!") ; return}
        
        
        XCTAssertThrowsError(try sut.paginate())
    
    }
    
}
