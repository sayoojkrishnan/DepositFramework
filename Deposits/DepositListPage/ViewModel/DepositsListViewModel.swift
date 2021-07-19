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
    
    private  var bag = Set<AnyCancellable>()
    private var total : Double = 0
    
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


//MARK: Deposits list data source
extension DepositsListViewModel {
    
    func depositViewModelFor(indexPath : IndexPath ) ->DepositViewModel {
        deposits[indexPath.row]
    }
    
    var totalDeposits : String {
        return "$" + String(format: "%.2f", total)
    }
    
    var numberOfSections : Int {
        return 2
    }
    
    func sectionHeaderTitle(for section : Int) -> String {
        return Sections.sectionHeader(for: section)
    }
    
    func numberOfRowsInSection(section : Int) -> Int {
        if section == 0 {
            return 1
        }
        return deposits.count
    }
    
}
