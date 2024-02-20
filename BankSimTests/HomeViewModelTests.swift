//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import XCTest
import Combine
@testable import BankSim

final class HomeViewModelTests: XCTestCase {
    
    var sut: HomeViewModel!
    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        Database.reset()
        Repository.responseDelay = 0
        sut = HomeViewModel()
    }

    override func tearDown() {
        sut = nil
    }

    func testHomeViewModel_onFetch_SuccessfulReturn() {
        let userExp = expectation(description: "")
        let accountsExp = expectation(description: "")

        sut.fetch()
        XCTAssertTrue(sut.userName.isEmpty)
        XCTAssertTrue(sut.accounts.isEmpty)

        sut.$userName
            .compactMap {!$0.isEmpty ? $0 : nil}
            .sink { value in
                XCTAssertEqual(value, "Pedro")
                userExp.fulfill()
            }
            .store(in: &cancellables)
        sut.$accounts
            .compactMap {!$0.isEmpty ? $0 : nil}
            .sink { value in
                XCTAssertEqual(value.count, 3)
                accountsExp.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [userExp, accountsExp], timeout: 1)
    }
}
