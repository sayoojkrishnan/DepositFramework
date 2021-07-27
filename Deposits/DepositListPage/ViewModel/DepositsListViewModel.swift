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
        
        var isLoading : Bool {
            switch self {
            case .loading:
                return true
            default:
                return false
            }
        }
        
        var isSuccess : Bool {
            switch self {
            case .success:
                return true
            default:
                return false
            }
        }
        
        var error : String? {
            switch self {
            case .failed(let err):
                return err
            default:
                return nil
            }
        }
    }
    
    private(set) var offset : Int = 0
    private var pageSize : Int = 5
    private(set) var hasMoreData : Bool = true
    private var bag = Set<AnyCancellable>()
    private(set) var total : Double = 0
    
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
    
    enum PaginationError : Error {
        case noMoreData
    }
    
    func paginate() throws  {
        if !hasMoreData {
            throw PaginationError.noMoreData
        }
        fetchDeposits()
    }
    
    func fetchDeposits() {
        
        viewState = .loading
        depositService.fetchDeposits(pageSize: pageSize, offset: offset)
            .receive(on: RunLoop.main)
            .sink { [weak self ] response in
                switch response {
                case .failure(let error) :
                    self?.viewState = .failed(error.desciprtion)
                case .finished :
                    self?.viewState = .success
                }
                
            } receiveValue: { [weak self ] deposits in
                print("Deposits count \(deposits.count)")
                if deposits.count < 1  {
                    self?.hasMoreData = false
                }
                self?.offset+=deposits.count
                let viewModels = deposits.map({DepositViewModel(deposit: $0)})
                var unsortedDeposits = self?.deposits ?? []
                unsortedDeposits.append(contentsOf: viewModels)
                self?.deposits = unsortedDeposits.sorted(by: {$0.addedDate > $1.addedDate})
                self?.total += deposits.reduce(0, { prev, model in return prev + model.amount })
            }.store(in: &bag)
        
    }
    
    
    func deposit(deposit : DepositModel) {
        
        deposits.append(DepositViewModel(deposit: deposit))
        deposits = deposits.sorted(by: {$0.addedDate > $1.addedDate})
        total += deposit.amount
    }
}
