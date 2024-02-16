//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import Foundation
import SwiftUI

struct Transaction {
    let id: UUID
    let type: `Type`
    let amount: Amount
    let date: Date

    init(id: UUID = UUID(), type: `Type`, amount: Amount, date: Date = .now) {
        self.id = id
        self.type = type
        self.amount = amount
        self.date = date
    }

    enum `Type` {
        case withdraw
        case deposit

        var prefix: String {
            switch self {
            case .withdraw: "-"
            case .deposit: "+"
            }
        }

        var color: Color {
            switch self {
            case .withdraw: .red
            case .deposit: .green
            }
        }
    }

}
