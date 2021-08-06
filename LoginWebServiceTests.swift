//
//  LoginWebServiceTests.swift
//  DepositsTests
//
//  Created by Biswajit Palei on 29/07/21.
//

import XCTest
import Combine
@testable import Deposits

class LoginWebServiceTests: XCTestCase {

    var sut:LoginService!
    
    override func setUp() {
        sut = LoginService()
    }
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = nil
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoginWebService_WhenGivenFullResponse_ReturnSuccess(){
        let loginParamRequestModel = LoginParamRequestModel(email: "email@gmail.com", password: "12345678")
//        sut.login(loginParamRequestModel: loginParamRequestModel){
//            return
//        }
    }
}
