//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import XCTest
@testable import BankSim

final class BankSimAccountTests: ScreenTestCase {

    override func setUp() {
        Repository.responseDelay = 0
        UIView.setAnimationsEnabled(false)
    }

    func testAccountScreen() throws {

        let exp = expectation(description: "")

        Task { @MainActor in
            try await StartAccountScreen()
                .waitForPresentation()
                .givenISeeAccountDetails()
                .andIDepositMoneyTwice()
                .wait(for: 1)
                .iSee2Transactions()
                .fulfill(exp)
        }

        waitForExpectations(timeout: 10)
    }

    var coordinator: AccountCoordinator?
    @discardableResult
    func StartAccountScreen() -> Self {
        coordinator = navigationController.map {
            AccountCoordinator(
                navigationController: $0,
                viewModel: AccountViewModel(accountRequest: Database.account.id)
            )
        }
        coordinator?.start()
        return self
    }

    @discardableResult
    func givenISeeAccountDetails(_ message: String = "", file: StaticString = #filePath, line: UInt = #line) throws -> Self {
        let view = find(by: Accessibility.Account.header)
        XCTAssertNotNil(view, message, file: file, line: line)
        return self
    }

    @discardableResult
    func andIDepositMoneyTwice(_ message: String = "", file: StaticString = #filePath, line: UInt = #line) throws -> Self {
        coordinator?.viewModel.deposit(amountString: "200")
        coordinator?.viewModel.deposit(amountString: "200")
        return self
    }

    @discardableResult
    func iSee2Transactions(_ message: String = "", file: StaticString = #filePath, line: UInt = #line) throws -> Self {
        let cellView = filter(by: Accessibility.Account.cell)
        XCTAssertEqual(cellView?.count, 2, message, file: file, line: line)
        return self
    }
}
