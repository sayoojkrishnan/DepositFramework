//
//  DepositListTableViewDataSourceTests.swift
//  DepositsTests
//
//  Created by Sayooj Krishnan  on 23/07/21.
//
@testable import Deposits
import XCTest

class DepositListTableViewDataSourceTests: XCTestCase {
    
    var tableview : UITableView!
    var sut : DepositListTableViewDataSource!
    
    
    override func setUpWithError() throws {
        
//        tableview = UITableView()
//        let dummy =  DepositModel.dummy
//        let depositViewModel = DepositViewModel(deposit: dummy)
//        sut = DepositListTableViewDataSource()
//        sut.updateData(deposits: [depositViewModel,depositViewModel], total: "$100", transcations: "20")
//        
//        let depositNib = UINib(nibName: "DepositTableViewCell", bundle: Bundle(for: DepositTableViewCell.self))
//        tableview.register(depositNib, forCellReuseIdentifier: "DepositTableViewCell")
//        let totalNib = UINib(nibName: "DepositsTotalCell", bundle: Bundle(for: DepositsTotalCell.self))
//        tableview.register(totalNib, forCellReuseIdentifier: "DepositsTotalCell")
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
//    func testDepositListTableViewDataSource_WhenTVMethodCalls_ShouldRespondWithValidData() {
//
//        let cellAtSectionZero = sut.tableView(tableview, cellForRowAt: IndexPath(row: 0, section: 0)) as? DepositsTotalCell
//        let cellAtSectionOne = sut.tableView(tableview, cellForRowAt: IndexPath(row: 0, section: 1)) as? DepositTableViewCell
//
//
//        XCTAssertEqual(sut.numberOfSections(in: tableview), 2)
//        XCTAssertEqual(sut.tableView(tableview, numberOfRowsInSection: 0), 1)
//        XCTAssertEqual(sut.tableView(tableview, numberOfRowsInSection: 1), 2)
//
//        XCTAssertNotNil(cellAtSectionZero)
//        XCTAssertNotNil(cellAtSectionOne)
//    }
    
}

