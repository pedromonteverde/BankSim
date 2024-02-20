//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import Foundation
import Combine

class AccountViewModel: ObservableObject {

    typealias AnyPublisherResult<T> = AnyPublisher<Result<T, Error>, Never>

    @Published var userName: String = ""
    @Published var accountType: Account.`Type` = .none
    @Published var accountBalance: Amount = 0
    @Published var transactions: [Transaction] = []

    @Published var error: Error?
    @Published var accountRequest: AccountRequest

    var cancellables = Set<AnyCancellable>()

    let validator: Validating

    private let repository = Repository()
    private let userSubject = PassthroughSubject<Void, Never>()
    private let accountSubject = PassthroughSubject<AccountRequest, Never>()
    private let transactionSubject = PassthroughSubject<(Transaction, AccountRequest), Never>()

    private var userPublisher: AnyPublisherResult<User> {
        userSubject
            .tryAwait(repository.fetchUser)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private var accountPublisher: AnyPublisherResult<Account> {
        accountSubject
            .tryAwait(repository.fetchAccount)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private var transactionPublisher: AnyPublisherResult<(Amount, Transaction)> {
        transactionSubject
            .tryAwait(repository.requestTransaction)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    init(accountRequest: AccountRequest) {
        self.accountRequest = accountRequest
        validator = Validator()

        subscribe(to: transactionPublisher) { (balance, transaction) in
            self.accountBalance = balance
            self.transactions.append(transaction)
        }
    }

    func fetch() {
        Publishers.CombineLatest(userPublisher, accountPublisher)
            .sink { resultA, resultB in
                switch resultA {
                case .success(let user):
                    self.userName = user.name
                case .failure(let error):
                    self.error = error
                }
                switch resultB {
                case .success(let account):
                    self.accountBalance = account.balance
                    self.transactions = account.transactions
                    self.accountType = account.type
                case .failure(let error):
                    self.error = error
                }
            }
            .store(in: &cancellables)

        accountSubject.send(accountRequest)
        userSubject.send()
    }

    func withdraw(amountString: String) {
        error.tryCatch {
            let amount = try validator.validate(amountString)
            transactionSubject.send((Transaction(type: .withdraw, amount: amount), accountRequest))
        }
    }

    func deposit(amountString: String) {
        error.tryCatch {
            let amount = try validator.validate(amountString)
            transactionSubject.send((Transaction(type: .deposit, amount: amount), accountRequest))
        }
    }

    private func subscribe<T>(
        to publisher: AnyPublisherResult<T>,
        onSuccess: @escaping (T) -> Void
    ) {
        publisher
            .sink {
                switch $0 {
                case .success(let success):
                    onSuccess(success)
                case .failure(let error):
                    self.error = error
                }
            }
            .store(in: &cancellables)
    }
}
