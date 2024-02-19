//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import SwiftUI

struct AccountCellView: View {

    var accountType: Account.`Type`
    var accountBalance: Amount = 0

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(accountType.descrition)
                    .font(.callout)
                    .foregroundStyle(Color.gray)
                Text("\(formatCurrency(from: accountBalance))")
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Color.gray)
        }
        .background(Color.white)
    }
}
