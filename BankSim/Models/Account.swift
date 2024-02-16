//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import Foundation

class Account {
    let id: UUID
    let type: `Type`
    var balance: Amount
    var transactions: [Transaction]

    init(
        id: UUID = UUID(),
        type: `Type`,
        balance: Amount,
        transactions: [Transaction] = []
    ) {
        self.id = id
        self.type = type
        self.balance = balance
        self.transactions = transactions
    }

    enum `Type` {
        case none
        case current
        case savings
        case salary

        var descrition: String {
            switch self {
            case .none:
                ""
            case .current:
                "🚀 Current"
            case .savings:
                "💼 Savings"
            case .salary:
                "🏤 Salary"
            }
        }
    }
}
