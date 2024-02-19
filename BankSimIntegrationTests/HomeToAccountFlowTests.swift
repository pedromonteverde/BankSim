//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import XCTest
import SwiftUI
@testable import BankSim

final class HomeToAccountFlowTests: XCTestCase, Screen {

    var exp: XCTestExpectation?

    override func setUp() {
        super.setUp()
        exp = expectation(description: "")
    }

    func fullfill() {
        exp?.fulfill()
    }

    func testHomeToAccountFlow() throws {

        Task { @MainActor in
            try await GivenImAtTheHomeScreen()
                .andWait(for: 3)
                .tap1stBankAccount()
                .navigateToAtTheAccountScreen()
                .andWait(for: 2)
                .fullfill()
        }

        waitForExpectations(timeout: 10)
    }

    @discardableResult
    func GivenImAtTheHomeScreen() -> Self {
        navigationController.map {
            HomeCoordinator(navigationController: $0)
        }?.start()
        return self
    }

    @discardableResult
    func tap1stBankAccount(_ message: String = "", file: StaticString = #filePath, line: UInt = #line) throws -> Self {
        let cellView = find(by: Accessibility.Home.cell)
        let cell = try? XCTUnwrap(cellView as? UICollectionViewCell, message)
        XCTAssertNotNil(cell, message)
        let listView = find(by: Accessibility.Home.list)
        let list = try? XCTUnwrap(listView as? UICollectionView, message)
        list?.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .bottom)
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
