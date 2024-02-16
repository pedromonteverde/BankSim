//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import SwiftUI

struct TransactionCellView: View {

    @State var transaction: Transaction

    var body: some View {
        HStack {
            let type = transaction.type
            Text(type.prefix + "\(formatCurrency(from: transaction.amount))")
                .foregroundStyle(type.color)
            Spacer()
            Text(formatDate(transaction.date))
                .foregroundStyle(Color.gray)
                .font(.footnote)
        }
    }
}
