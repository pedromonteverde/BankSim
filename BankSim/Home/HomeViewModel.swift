//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {

    typealias AnyPublisherResult<T> = AnyPublisher<Result<T, Error>, Never>

    @Published var userName: String = ""
    @Published var accounts: [Account] = []
    @Published var error: Error?

    var cancellables = Set<AnyCancellable>()

    private let repository = Repository()
    private let userSubject = PassthroughSubject<Void, Never>()

    private var userPublisher: AnyPublisherResult<User> {
        userSubject
            .tryAwait(repository.fetchUser)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    init() {
        subscribe(to: userPublisher) {
            self.userName = $0.name
            self.accounts = $0.accounts
        }
    }

    func fetch() {
        userSubject.send()
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
