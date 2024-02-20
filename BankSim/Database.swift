//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import Foundation

struct Database {

    static let account = Account(
        type: .current,
        balance: 10000
    )
    
    static let user = User(
        name: "Pedro",
        accounts: [
            account,
            Account(
                type: .savings,
                balance: 7800
            ),
            Account(
                type: .salary,
                balance: 780
            )
        ]
    )

    static func reset() {
        account.transactions.removeAll()
        account.balance = 10000
        user.accounts[1].balance = 7800
        user.accounts[2].balance = 780
    }
}
