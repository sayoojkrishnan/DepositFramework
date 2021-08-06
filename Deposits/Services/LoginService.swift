//
//  LoginService.swift
//  Deposits
//
//  Created by Biswajit Palei on 28/07/21.
//

import Foundation
import Combine

protocol LoginServiceProtocol: MockNeworkServiceBuildable {
    func login(loginParamRequestModel:LoginParamRequestModel) ->AnyPublisher<LoginResponseModel,LoginError>
}

final class LoginService:LoginServiceProtocol{
    
    var mockType: MockType? = nil
    
    func login(loginParamRequestModel:LoginParamRequestModel) -> AnyPublisher<LoginResponseModel, LoginError> {
        _ = LoginDataRequestModel(params: [
            "email" : loginParamRequestModel.email,
            "password" : loginParamRequestModel.password
        ])
        return Future<LoginResponseModel, LoginError>{ promise in
            let response = LoginResponseModel(firstName: "First", lastName: "Last", email: "email@gmail.com")
            promise(.success(response))
        }.eraseToAnyPublisher()
//        let client = client
//
//        return client
//            .request(type: [LoginResponseModel].self, serviceRequest: request)
//            .mapError({ error in
//                switch error {
//                case .failedToConnectToHost :
//                    return .noInternet
//                default :
//                    return LoginError.loginFailed
//                }
//            })
//            .eraseToAnyPublisher()
    }
//    func login(loginDataRequestModel:LoginDataRequestModel, completion: @escaping (Result<LoginResponseModel, LoginError>) -> Void) {
//    }
}
