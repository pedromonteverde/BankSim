//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import Foundation

enum AccountError: LocalizedError {
    case notFound(AccountRequest)

    var errorDescription: String? {
        switch self {
        case .notFound(let account):
            "🚫 Invalid account \(account)"
        }
    }
}

enum TransferError: LocalizedError {
    case notEnoughBalance(Amount)
    case notAuthorized(Amount)

    var errorDescription: String? {
        switch self {
        case .notEnoughBalance(let amount):
            "🚫 Not enough balance to withdraw: \(amount)"
        case .notAuthorized(let amount):
            "⛔️ Not enough balance to withdraw: \(amount) authorized"
        }
    }
}

enum ValidationError: LocalizedError {
    case invalidAmount
    case notPositiveAmount

    var errorDescription: String? {
        switch self {
        case .invalidAmount:
            "🚫 Invalid amount format"
        case .notPositiveAmount:
            "⛔️ The amount entered needs to be greater than 0"
        }
    }
}
