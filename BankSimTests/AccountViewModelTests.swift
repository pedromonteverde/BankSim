//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import XCTest
import Combine
@testable import BankSim

final class AccountViewModelTests: XCTestCase {

    var sut: AccountViewModel!
    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        Repository.responseDelay = 0
        sut = AccountViewModel(accountRequest: Tests.validAccountRequest)
    }

    override func tearDown() {
        sut = nil
    }

    func testAccountViewModel_onFetch_SuccessfulReturn() {
        let userExp = expectation(description: "")
        let balanceExp = expectation(description: "")

        sut.fetch()
        XCTAssertTrue(sut.userName.isEmpty)
        XCTAssertEqual(sut.accountBalance, 0)

        sut.$userName
            .compactMap {!$0.isEmpty ? $0 : nil}
            .sink { value in
                XCTAssertEqual(value, "Pedro")
                userExp.fulfill()
            }
            .store(in: &cancellables)
        
        sut.$accountBalance
            .compactMap {($0 > 0) ? $0 : nil}
            .sink { value in
                XCTAssertEqual(value, Database.account.balance)
                balanceExp.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [userExp, balanceExp], timeout: 1)
    }

    func testAccountViewModel_onDepositAndWithdraw_SuccessfulTransactions() {
        let transactionsExp = expectation(description: "")

        XCTAssertTrue(sut.transactions.isEmpty)

        sut.deposit(amountString: "200")
        sut.withdraw(amountString: "300")
        sut.deposit(amountString: "400")
        sut.withdraw(amountString: "500")

        sut.$transactions
            .compactMap { $0.count == 4 ? $0 : nil }
            .sink { value in
                XCTAssertEqual(
                    value.map { $0.amount }.sorted(),
                    [200, 300, 400, 500]
                )
                transactionsExp.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [transactionsExp], timeout: 1)
    }
}

extension AccountViewModelTests {
    enum Tests {
        static let validAccountRequest = Database.account.id
    }
}
