//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import XCTest
@testable import BankSim

final class CoordinatorFlowTests: XCTestCase {

    var homeCoordinator: HomeCoordinator!

    override func setUp() {
        homeCoordinator = HomeCoordinator(navigationController: Tests.dummyNavigationController)
    }

    override func tearDown() {
        homeCoordinator = nil
    }

    func testHomeCoordinator_onStartingAccountCoordinator() {
        homeCoordinator.start()
        XCTAssertEqual(homeCoordinator.children.count, 0)
        homeCoordinator.goToAccount(Tests.dummyAccountRequest)
        XCTAssertEqual(homeCoordinator.children.count, 1)
    }

    func testHomeCoordinator_onDismissingAccountCoordinator() throws {
        homeCoordinator.goToAccount(Tests.dummyAccountRequest)
        XCTAssertEqual(homeCoordinator.children.count, 1)
        let accountCoordinator = try XCTUnwrap(homeCoordinator.children.first as? AccountCoordinator)
        accountCoordinator.dismiss()
        XCTAssertEqual(homeCoordinator.children.count, 0)
    }
}

extension CoordinatorFlowTests {
    enum Tests {
        static let dummyNavigationController = UINavigationController()
        static let dummyAccountRequest = UUID()
    }
}
