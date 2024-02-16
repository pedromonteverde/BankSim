//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import SwiftUI

struct AccountHeaderView: View {

    @StateObject var viewModel: AccountViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.accountType.descrition)
                .font(.callout)
                .foregroundStyle(Color.gray)
            Text("👤 User: \(viewModel.userName)" )
            Text("💰 Balance: \(formatCurrency(from: viewModel.accountBalance))")
        }
    }
}

func formatCurrency(from number: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale.current
    return formatter.string(from: number as NSNumber) ?? ""
}
