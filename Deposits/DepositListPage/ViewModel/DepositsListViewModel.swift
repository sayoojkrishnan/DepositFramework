//
//  DepositsViewModel.swift
//  Deposits
//
//  Created by Swathi on 14/07/21.
//


import Foundation
import Combine

final class DepositsListViewModel  : ObservableObject {
    typealias PaginationState = DepositViewState
    typealias DepositReponse = Subscribers.Completion<DepositError>
    
    enum DepositViewState {
        case loading
        case failed
        case success
    }
    
    private(set) var offset : Int = 0
    private var pageSize : Int = 15
    private(set) var hasMoreData : Bool = true
    private var bag = Set<AnyCancellable>()
    private(set) var total : Double = 0
    
    private(set) var error : String?
    
    var totalDeposits : String {
        return "$" + String(format: "%.2f", total)
    }
    
    var numberOfTransaction : String {
        return "From \(deposits.count) transaction" + "\(deposits.count > 1 ? "s":"")"
    }
    
    enum RefreshDepositsState {
        case noNewItem
        case refreshed
        
        var message : String {
            switch self {
            case .noNewItem:
                return "No new deposits available!"
            case .refreshed :
                return "Latest deposits have been added to the list"
            }
        }
    }
    
    let timer = Timer.publish(every: 60*1, on: .main, in: .default)
    
    @Published var refreshDepositsListResult : RefreshDepositsState?
    @Published var paginationState : PaginationState = .success
    @Published var viewState : DepositViewState?
    @Published var deposits : [DepositViewModel] = []
    
    let depositService : DepositsListServiceProtocol
    init(service : DepositsListServiceProtocol = DepositListsService()) {
        self.depositService = service
        
        timer.autoconnect()
            .receive(on: DispatchQueue.global())
            .sink { [weak self]_ in
                self?.refresh(withAlert: false)
            }.store(in: &bag)
    }
    
    enum PaginationError : Error {
        case noMoreData
    }
    
    
    
    private func getDeposits(
        pageSize: Int,
        offset: Int ,
        stateCallBack : @escaping (DepositReponse)->Void,
        depositsCallBack : @escaping ([DepositViewModel])->Void
    ) {
        depositService.fetchDeposits(pageSize: pageSize, offset: offset)
            .receive(on: RunLoop.main)
            .sink { stateCallBack($0)}
                receiveValue: {  deposits in
                    depositsCallBack(deposits.map({DepositViewModel(deposit: $0)}))
                }.store(in: &bag)
    }
    
    
    func initialFetch() {
        viewState = .loading
        getDeposits(pageSize: pageSize, offset: offset) {[weak self] res in
            switch res {
            case .failure(let error) :
                self?.viewState = .failed
                self?.error = error.desciprtion
            case .finished :
                self?.viewState = .success
            }
        } depositsCallBack: { [weak self] deposits in
            self?.appendDeposits(deposits: deposits)
        }
    }
    
    func paginate() throws  {
        if !hasMoreData {
            throw PaginationError.noMoreData
        }
        paginationState = .loading
        
        getDeposits(pageSize: pageSize, offset: offset) { [weak self] res  in
            switch res {
            case .failure(let error) :
                self?.paginationState = .failed
                self?.error = error.desciprtion
            case .finished :
                self?.paginationState = .success
            }
        } depositsCallBack: { [weak self] deposits in
            self?.appendDeposits(deposits: deposits)
        }
        
    }
    
    func refresh(withAlert : Bool = true) {
        print("Refreshe called with \(withAlert)")
        viewState = .loading
        getDeposits(pageSize: 10, offset: 0) {[weak self] res in
            switch res {
            case .failure(let error) :
                self?.viewState = .failed
                self?.error = error.desciprtion
            case .finished :
                self?.viewState = .success
            }
        } depositsCallBack: { [weak self] newDeposits in
            guard let this = self else {return}
            // Expecting the server to return deposits in sorted order
            var availableDeposits = this.deposits
            newDeposits.forEach({
                // n2 complexity
                if !availableDeposits.contains($0) {
                    availableDeposits.append($0)
                }
            })
            
           
            if withAlert {
                // No new deposit available
                if this.deposits.count == availableDeposits.count {
                    this.refreshDepositsListResult = .noNewItem
                }else {
                    this.refreshDepositsListResult = .refreshed
                }
            }
           
            this.deposits = availableDeposits
        }
    }
    
    
    private func appendDeposits(deposits : [DepositViewModel]) {
        if deposits.count < 1  {
            hasMoreData = false
        }
        offset+=deposits.count
        // self?.deposits = unsortedDeposits.sorted(by: {$0.addedDate > $1.addedDate})
        // Expecting the server to return deposits in sorted order
        self.deposits.append(contentsOf: deposits)
        total += deposits.reduce(0, { prev, model in return prev + model.amount })
    }
    
    func deposit(deposit : DepositModel) {
        deposits.append(DepositViewModel(deposit: deposit))
        deposits = deposits.sorted(by: {$0.addedDate > $1.addedDate})
        total += deposit.amount
    }
}
