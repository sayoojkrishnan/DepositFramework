//
//  ScanChequeViewModelTest.swift
//  DepositsTests
//
//  Created by Sayooj Krishnan  on 23/07/21.
//

@testable import Deposits
import XCTest
import Combine

class ScanChequeViewModelTest: XCTestCase {
    
    var sut : ScanChequeViewModel!
    var service : MockDepositChequeSerice!
    
    override func setUpWithError() throws {
        service = MockDepositChequeSerice()
        sut = ScanChequeViewModel(service: service)
    }

    override func tearDownWithError() throws {
       sut = nil
    }

   
    
    func testScanChequeViewModel_WhenDepositCalledWithEmptyData_ShouldNotCallAPI() {
       // Date, amount , description are empty by default
        sut.deposit()
        XCTAssertFalse(service.didCallDepositCheque)
    }
    
    func testScanChequeViewModel_WhenDepositCalledWithProperData_ShouldCallAPI() {
        sut.amount = "100"
        sut.date = Date()
        sut.chequeDescription = "iOS Deposit"
        sut.deposit()
        XCTAssertTrue(service.didCallDepositCheque)
    }
    
    
    
    func testScanChequeViewModel_WhenDepositIsSuccessfull_ShouldChangeStateToSuccess() {
        
        sut.amount = "100"
        sut.date = Date()
        sut.chequeDescription = "iOS Deposit"
        service.sucessResponse = DepositModel.dummy
        sut.deposit()
        
        let expectation = expectation(description: "stateChange")
        let result = XCTWaiter.wait(for: [expectation], timeout: 0.5)
        if result == XCTWaiter.Result.timedOut {
            switch sut.state.value {
            case .deposited(let model):
                XCTAssertEqual(model.amount, 100)
            default:
                XCTFail("State should be deposited")
                break
            }
        }
        
    }
    
    func testScanChequeViewModel_WhenDepositFailed_ShouldChangeStateToFailed() {
        
        sut.amount = "100"
        sut.date = Date()
        sut.chequeDescription = "iOS Deposit"
        service.failedResponse = .failedToDeposit
        sut.deposit()
        
        let expectation = expectation(description: "stateChange")
        let result = XCTWaiter.wait(for: [expectation], timeout: 0.5)
        if result == XCTWaiter.Result.timedOut {
            switch sut.state.value {
            case .failed(let err):
                XCTAssertEqual(err, service.failedResponse?.desciprtion)
            default:
                XCTFail("State should be failed")
                break
            }
        }
        
    }

}


class MockDepositChequeSerice : DepositChequeServiceProtocol {
    var failedResponse : DepositError?
    var sucessResponse : DepositModel?
    var didCallDepositCheque : Bool = false
    func depositCheuqe(param: [String : Any]) -> AnyPublisher<DepositModel, DepositError> {
        didCallDepositCheque = true
        return Future<DepositModel, DepositError>{ promise in
    
            if let error =  self.failedResponse {
                promise(.failure(error))
                return
            }
            
            if let success = self.sucessResponse {
                promise(.success(success))
            }
        }.eraseToAnyPublisher()
    }
    
    var mockType: MockType?
    
    
}
