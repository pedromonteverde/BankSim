//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import Foundation

typealias AccountRequest = UUID
typealias Amount = Double

actor Repository {

    let responseDelay: UInt64 = 1 * 1000000000

    func fetchUser() async throws -> User {
        try await Task.sleep(nanoseconds: responseDelay)
        let user = Database.user
        return user
    }

    func fetchAccount(from request: AccountRequest) async throws -> Account  {
        let account = Database.user.accounts.first { $0.id == request }
        guard let account else {
            throw AccountError.notFound(request)
        }
        return account
    }

    func requestTransaction(_ transaction: Transaction, for request: AccountRequest) async throws -> (Amount, Transaction) {
        let account = try await fetchAccount(from: request)
        switch transaction.type {
        case .withdraw:
            let balance = try await withdraw(transaction, from: account)
            return (balance, transaction)
        case .deposit:
            let balance = try await deposit(transaction, to: account)
            return (balance, transaction)
        }
    }

    private func withdraw(_ transaction: Transaction, from account: Account) async throws -> Amount {

        let amount = transaction.amount

        guard canWithdraw(amount, from: account) else {
            throw TransferError.notEnoughBalance(amount)
        }

        guard try await authorizeTransaction() else {
            throw TransferError.notAuthorized(amount)
        }

        // Check balance again after the authorization process
        guard canWithdraw(amount, from: account) else {
            throw TransferError.notAuthorized(amount)
        }

        account.transactions.append(transaction)
        account.balance -= amount
        return account.balance
    }

    private func deposit(_ transaction: Transaction, to account: Account) async throws -> Amount {

        let amount = transaction.amount

        guard try await authorizeTransaction() else {
            throw TransferError.notAuthorized(amount)
        }

        account.balance += amount
        account.transactions.append(transaction)
        return account.balance
    }

    private func canWithdraw(_ amount: Amount, from account: Account) -> Bool {
        amount <= account.balance
    }

    private func authorizeTransaction() async throws -> Bool {
        try await Task.sleep(nanoseconds: responseDelay)
        return true
    }
}
