//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import XCTest
@testable import BankSim

final class HomeToAccountFlowTests: XCTestCase, Screen {

    func testHomeToAccountFlow() throws {

        let exp = expectation(description: "")

        Task { @MainActor in
            try await StartHomeScreen()
                .andWait(for: 3)
                .tap1stBankAccount()
                .navigateToAtTheAccountScreen()
                .andWait(for: 2)
                .fulfill(exp)
        }

        waitForExpectations(timeout: 10)
    }

    @discardableResult
    func StartHomeScreen() -> Self {
        navigationController.map {
            HomeCoordinator(navigationController: $0)
        }?.start()
        return self
    }

    @discardableResult
    func tap1stBankAccount(_ message: String = "", file: StaticString = #filePath, line: UInt = #line) throws -> Self {
        let cellView = find(by: Accessibility.Home.cell)
        let cell = try XCTUnwrap(cellView as? UICollectionViewCell, message, file: file, line: line)
        XCTAssertNotNil(cell, message, file: file, line: line)
        let listView = find(by: Accessibility.Home.list)
        let list = try XCTUnwrap(listView as? UICollectionView, message, file: file, line: line)
        list.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .bottom)
        return self
    }

    @discardableResult
    func navigateToAtTheAccountScreen() -> Self {
        navigationController.map {
            AccountCoordinator(
                navigationController: $0,
                viewModel: AccountViewModel(accountRequest: Database.account.id)
            )
        }?.start()
        return self
    }
}
