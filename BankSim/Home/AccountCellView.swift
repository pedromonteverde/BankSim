//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import SwiftUI

struct AccountCellView: View {

    var accountType: Account.`Type`
    var accountBalance: Amount = 0

    var body: some View {
        VStack(alignment: .leading) {
            Text(accountType.descrition)
                .font(.callout)
                .foregroundStyle(Color.gray)
            Text("\(formatCurrency(from: accountBalance))")
        }
    }
}
