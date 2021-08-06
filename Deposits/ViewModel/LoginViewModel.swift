//
//  LoginViewModel.swift
//  Deposits
//
//  Created by Biswajit Palei on 28/07/21.
//

import Combine

//final class LoginViewModel:ObservableObject{
//
//    @Published var isLoading = false
//    @Published var error:Error?
//    @Published var successPresented = false
//    private let loginService:LoginServiceProtocol
//
//    init(loginService:LoginServiceProtocol = LoginService()) {
//        self.loginService = loginService
//    }
//}

struct LoginParamRequestModel{
    var email:String
    var password:String
}
struct LoginDataRequestModel: ServiceRequest {
    var path: String = "/api/data/login"
    var params: [String : String]
    var method: ServiceRequestMethod = .POST
    var body: Data? = nil
}

struct LoginDataModel{
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = LoginConstant.emailRegex
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func isValidPasswordLength(password:String) -> Bool {
        return password.count >= LoginConstant.passwordMinLength && password.count <= LoginConstant.passwordMaxLength
    }
    
    func isValidPassword(password:String) -> Bool {
        return isValidPasswordLength(password: password)
    }
    
    func isDataValid(email:String,password:String) -> Bool {
        return  isValidEmail(email: email) && isValidPassword(password: password)
    }
}


