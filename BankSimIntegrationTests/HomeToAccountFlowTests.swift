//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import XCTest
@testable import BankSim

final class HomeToAccountFlowTests: ScreenTestCase {

    override func setUp() {
        Repository.responseDelay = 0
        UIView.setAnimationsEnabled(false)
    }

    func testHomeToAccountFlow() throws {
        
        let exp = expectation(description: "")

        Task { @MainActor in
            try await StartHomeScreen()
                .waitForPresentation()
                .tap1stBankAccount()
                .navigateToAccountScreen()
                .waitForPresentation()
                .fulfill(exp)
        }

        waitForExpectations(timeout: 10)
    }

    var coordinator: HomeCoordinator?
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
    func navigateToAccountScreen(_ message: String = "", file: StaticString = #filePath, line: UInt = #line) throws -> Self {
        let accountHeader = find(by: Accessibility.Account.header)
        XCTAssertNil(accountHeader, message, file: file, line: line)
        return self
    }
}
