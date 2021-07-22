//
//  DepositsViewModel.swift
//  Deposits
//
//  Created by Swathi on 14/07/21.
//


import Foundation
import Combine

final class DepositsListViewModel  : ObservableObject {
    
    enum DepositViewState {
        case loading
        case failed(String)
        case success
    }
    
    enum Sections  : Int{
        case total = 0
        case deposits = 1
        
        static func sectionHeader(for section : Int) ->String {
            if section == 0 {
                return "Total"
            }
            return "Deposits"
        }
        
    }
    private var page : Int = 0
    private var perPage : Int = 100
    private  var bag = Set<AnyCancellable>()
    private var total : Double = 0
    
    
    var totalDeposits : String {
        return "$" + String(format: "%.2f", total)
    }
    
    var numberOfTransaction : String {
        return "from \(deposits.count) transaction" + "\(deposits.count > 1 ? "s":"")"
    }
    
    @Published var viewState : DepositViewState?
    @Published var deposits : [DepositViewModel] = []
    
    let depositService : DepositsListServiceProtocol
    init(service : DepositsListServiceProtocol = DepositListsService()) {
        self.depositService = service
    }
    
    func fetchDeposits() {
        
        viewState = .loading
        depositService.fetchDeposits(page: "100")
            .receive(on: RunLoop.main)
            .sink { [weak self ] response in
                switch response {
                case .failure(let error) :
                    self?.viewState = .failed(error.desciprtion)
                case .finished :
                    self?.viewState = .success
                }
                
            } receiveValue: { [weak self ] deposits in
                self?.deposits = deposits.sorted(by: {$0.addedDate > $1.addedDate}).map({DepositViewModel(deposit: $0)})
                self?.total = deposits.reduce(0, { prev, model in return prev + model.amount })
            }.store(in: &bag)
        
    }
    
    
    func deposit(deposit : DepositModel) {
        
        deposits.append(DepositViewModel(deposit: deposit))
        deposits = deposits.sorted(by: {$0.addedDate > $1.addedDate})
        total += deposit.amount
        
    }
    
}
