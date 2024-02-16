//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import Foundation

struct User {
    let id: UUID
    let name: String
    var accounts: [Account]

    init(id: UUID = UUID(), name: String, accounts: [Account] = []) {
        self.id = id
        self.name = name
        self.accounts = accounts
    }
}
