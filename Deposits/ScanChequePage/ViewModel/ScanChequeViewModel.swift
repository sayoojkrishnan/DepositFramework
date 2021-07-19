//
//  ScanChequeViewModel.swift
//  DepositsFramework
//
//  Created by Sayooj Krishnan  on 16/07/21.
//

import Foundation
import Combine

class ScanChequeViewModel  {
    
    enum ViewState {
        case depositing
        case deposited(DepositModel)
        case failed(String)
        case initial
    }
    
    private(set) var state =  CurrentValueSubject<ViewState,Never>(.initial)
    var chequeDescription : String = ""
    var date : Date = Date()
    var amount : String = ""
    
    var chequeFrontImageData : Data?
    var chequeBackImageData : Date?
    
    let service : DepositChequeServiceProtocol
    init(service : DepositChequeServiceProtocol = DepositChequeService()) {
        self.service = service
    }
    

    var depositCancellable : AnyCancellable?
    
    func deposit(){
        guard let amount = Double(amount),!chequeDescription.isEmpty  else {return}
        
        let depositDate = date.timeIntervalSince1970
        
        let params : [String:Any] = [
            "depositAmount" : amount,
            "depositDate": depositDate * 1000 ,
            "created" : Date().timeIntervalSince1970 * 1000,
            "depositDescription" : chequeDescription
        ]
        
        
        state.value = .depositing
        depositCancellable =  service.depositCheuqe(param: params)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {[weak self] response in
                switch response {
                case .finished :
                    break
                case .failure(let error) :
                    self?.state.value = .failed(error.desciprtion)
                }
            }, receiveValue: {[weak self] model in
                self?.state.value = .deposited(model)
            })
    }
}
