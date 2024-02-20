//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import XCTest
@testable import BankSim

final class RepositoryTests: XCTestCase {

    var repository: Repository!

    override func setUp() async throws {
        Database.reset()
        repository = Repository()
        Repository.responseDelay = 0
    }

    override func tearDown() async throws {
        repository = nil
    }

    func testRepository_depositMoney_updateBalance() async throws {
        let transaction = Transaction(type: .deposit, amount: 200)
        let (balance, resultTransaction) = try await repository.requestTransaction(transaction, for: Tests.accountRequest)
        XCTAssertEqual(balance, 10200)
        XCTAssertEqual(transaction.id, resultTransaction.id)
    }

    func testRepository_withdrawMoney_updateBalance() async throws {
        let transaction = Transaction(type: .withdraw, amount: 300)
        let (balance, resultTransaction) = try await repository.requestTransaction(transaction, for: Tests.accountRequest)
        XCTAssertEqual(balance, 9700)
        XCTAssertEqual(transaction.id, resultTransaction.id)
    }

    func testRepository_withdrawMoreThanAvailable_throwNotEnoughError() async throws {
        let transaction = Transaction(type: .withdraw, amount: 300000)
        do {
            _ = try await repository.requestTransaction(transaction, for: Tests.accountRequest)
            XCTFail()
        } catch {
            switch try XCTUnwrap(error as? TransferError) {
            case .notEnoughBalance(let amount):
                XCTAssertEqual(amount, 300000)
            case .notAuthorized:
                XCTFail()
            }
        }
    }

    func testRepository_withdrawTwiceSimultaneously_overSuspensionPoint_throwNotAuthorizedError() async throws {
        let exp = expectation(description: "")
        Repository.responseDelay = 100000000
        Task.detached {
            let transactionA = Transaction(type: .withdraw, amount: 5000)
            _ = try await self.repository.requestTransaction(transactionA, for: Tests.accountRequest)
        }
        Task.detached {
            do {
                let transactionB = Transaction(type: .withdraw, amount: 7000)
                _ = try await self.repository.requestTransaction(transactionB, for: Tests.accountRequest)
                print("")
            } catch {
                switch try XCTUnwrap(error as? TransferError) {
                case .notEnoughBalance(let amount):
                    XCTFail()
                case .notAuthorized:
                    exp.fulfill()
                }
            }
        }

        await fulfillment(of: [exp], timeout: 5)
    }
}

extension RepositoryTests {
    enum Tests {
        static let accountRequest = Database.account.id
    }
}
