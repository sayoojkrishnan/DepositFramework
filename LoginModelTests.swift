//
//  LoginModelTests.swift
//  DepositsTests
//
//  Created by Biswajit Palei on 28/07/21.
//

import XCTest
@testable import Deposits

class LoginModelTests: XCTestCase {

    var sut:LoginDataModel!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = LoginDataModel()
    }
    
    override func tearDown() {
       sut = nil
    }
    
    func testLoginModelTests_WhenEmailIsValid_ShouldReturnTrue(){
        //Arrange
        //Act
        let isEmailValid = sut.isValidEmail(email: "email@gmail.com")
        //Assert
        XCTAssertTrue(isEmailValid, "The isValidEmail() should have returned TRUE for a valid email but returned FALSE")
    }
    
    func testLoginModelTests_WhenPasswordIsValid_shouldReturnTrue(){
        //Arrange
        //Act
        let isValidPassword = sut.isValidPassword(password: "12345678")
        //Assert
        XCTAssertTrue(isValidPassword, "The isValidPassword() should have returned TRUE for a valid password which have more than \(LoginConstant.passwordMinLength) character and less than \(LoginConstant.passwordMaxLength) character but returned FALSE")
    }
    
    func testLoginModelTests_WhenInputDataIsValid_ShouldReturnTrue(){
        //Arrange
        //Act
        let isDataValid = sut.isDataValid(email:"email@gmail.com",password:"12345678")
        //Assert
        XCTAssertTrue(isDataValid, "The isDataValid() should have returned TRUE for a non valid data but returned FALSE")
    }
}
