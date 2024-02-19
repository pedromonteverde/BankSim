//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import XCTest
@testable import BankSim

final class BankSimFlowTests: ScreenTestCase {

    override func setUp() {
        Repository.responseDelay = 0
        UIView.setAnimationsEnabled(false)
    }

    func testHomeToAccountAndTransactionsFlow() throws {

        let exp = expectation(description: "")

        Task { @MainActor in
            try await StartHomeScreen()
                .waitForPresentation()
                .tap1stBankAccount()
                .waitForPresentation()
                .landOnAccountScreen()
                .depositMoney(200)
                .withdrawMoney(300)
                .withdrawMoney(300)
                .depositMoney(500)
                .wait(for: 1)
                .hasTheRightBalance(10100)
                .fulfill(exp)
        }

        waitForExpectations(timeout: 10)
    }

    var coordinator: HomeCoordinator?
    var accountCoordinator: AccountCoordinator?
    @discardableResult
    func StartHomeScreen() -> Self {
        navigationController.map {
            coordinator = HomeCoordinator(navigationController: $0)
        }
        coordinator?.start()
        return self
    }

    @discardableResult
    func tap1stBankAccount(_ message: String = "", file: StaticString = #filePath, line: UInt = #line) throws -> Self {
        let cellView = find(by: Accessibility.Home.cell)
        let cell = try XCTUnwrap(cellView as? UICollectionViewCell, message, file: file, line: line)
        XCTAssertNotNil(cell, message, file: file, line: line)
        let listView = find(by: Accessibility.Home.list)
        let list = try XCTUnwrap(listView as? UICollectionView, message, file: file, line: line)
        XCTAssertNotNil(list, message, file: file, line: line)
        coordinator?.goToAccount(Database.account.id)
        return self
    }

    @discardableResult
    func landOnAccountScreen(_ message: String = "", file: StaticString = #filePath, line: UInt = #line) throws -> Self {
        let accountHeader = find(by: Accessibility.Account.header)
        XCTAssertEqual(coordinator?.children.count, 1)
        accountCoordinator = try XCTUnwrap({ coordinator?.children.first as? AccountCoordinator }(), message, file: file, line: line)
        XCTAssertNotNil(accountHeader, message, file: file, line: line)
        return self
    }

    @discardableResult
    func depositMoney(_ amount: Double, _ message: String = "", file: StaticString = #filePath, line: UInt = #line) throws -> Self {
        accountCoordinator?.viewModel.deposit(amountString: "\(amount)")
        return self
    }

    @discardableResult
    func withdrawMoney(_ amount: Double, _ message: String = "", file: StaticString = #filePath, line: UInt = #line) throws -> Self {
        accountCoordinator?.viewModel.withdraw(amountString: "\(amount)")
        return self
    }

    @discardableResult
    func hasTheRightBalance(_ balance: Double, _ message: String = "", file: StaticString = #filePath, line: UInt = #line) throws -> Self {
        XCTAssertEqual(accountCoordinator?.viewModel.accountBalance, balance)
        return self
    }
}
