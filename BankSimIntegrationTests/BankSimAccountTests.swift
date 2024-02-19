//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import XCTest
@testable import BankSim

final class BankSimAccountTests: XCTestCase, Screen {

    func testAccountScreen() throws {

        let exp = expectation(description: "")

        Task { @MainActor in
            try await StartAccountScreen()
                .andWait(for: 1)
                .givenISeeAccountDetails()
                .andIDepositMoneyTwice()
                .iSee2Transactions()
                .fulfill(exp)
        }

        waitForExpectations(timeout: 10)
    }

    @discardableResult
    func StartAccountScreen() -> Self {
        navigationController.map {
            AccountCoordinator(
                navigationController: $0,
                viewModel: AccountViewModel(accountRequest: Database.account.id)
            )
        }?.start()
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
        let list = find(by: Accessibility.Account.list)
        XCTAssertNotNil(list, message, file: file, line: line)
        return self
    }

    @discardableResult
    func iSee2Transactions(_ message: String = "", file: StaticString = #filePath, line: UInt = #line) throws -> Self {
        let cellView = filter(by: Accessibility.Account.cell)
        XCTAssertEqual(cellView?.count, 0, message, file: file, line: line)
        return self
    }
}
