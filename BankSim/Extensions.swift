//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import SwiftUI
import Combine

public extension Publisher {
    func tryAwait<T>(
        _ transform: @escaping (Output) async throws -> T
    ) -> Publishers.FlatMap<Deferred<Future<Result<T, Error>, Never>>, Self> {
        flatMap { value in
            Deferred {
                Future { promise in
                    Task {
                        do {
                            let output = try await transform(value)
                            promise(.success(.success(output)))
                        } catch {
                            promise(.success(.failure(error)))
                        }
                    }
                }
            }
        }
    }
}

public extension View {
    func errorAlert(error: Binding<Error?>) -> some View {
        alert(
            error.wrappedValue?.localizedDescription ?? "",
            isPresented: .constant(error.wrappedValue != nil),
            actions: {
                Button("OK") {
                    error.wrappedValue = nil
                }
            }
        )
    }
}

extension Optional where Wrapped == Error {
    mutating func tryCatch( _ closure: () throws -> Void) {
        do { try closure() } catch { self = error }
    }
}
