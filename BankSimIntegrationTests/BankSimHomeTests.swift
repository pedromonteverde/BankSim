//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import XCTest
import SwiftUI
@testable import BankSim

final class BankSimHomeTests: XCTestCase, Screen {

    var exp: XCTestExpectation?

    override func setUp() {
        super.setUp()
        exp = expectation(description: "")
    }

    func fullfill() {
        exp?.fulfill()
    }

    func testHomeScreen() throws {

        Task { @MainActor in
            try await GivenImAtTheHomeScreen()
                .andWait(for: 2)
                .thenISeeUserProfileDetails()
                .andThereAreBankAccounts()
                .tap1stBankAccount()
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
    func thenISeeUserProfileDetails(_ message: String = "", file: StaticString = #filePath, line: UInt = #line) throws -> Self {
        let view = find(by: Accessibility.Home.header)
        XCTAssertNotNil(view, message, file: file, line: line)
        return self
    }

    @discardableResult
    func andThereAreBankAccounts(_ message: String = "", file: StaticString = #filePath, line: UInt = #line) throws -> Self {
        let list = find(by: Accessibility.Home.list)
        XCTAssertNotNil(list, message, file: file, line: line)
        let cells = filter(by: Accessibility.Home.cell)
        XCTAssertEqual(cells?.count, 3)
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
}
