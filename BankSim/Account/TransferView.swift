//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import SwiftUI
import SwiftUIIntrospect

struct TransferView: View {

    @ObservedObject var viewModel: AccountViewModel

    @State var amountToWithdraw: String = "200"
    @State var amountToDeposit: String = "300"

    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                Spacer()
                TextField("Withdraw", text: $amountToWithdraw)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                Button("Withdraw") {
                    viewModel.withdraw(amountString: amountToWithdraw)
                }
                .introspect(.view, on: .iOS(.v17)) {
                    $0.accessibilityIdentifier = Accessibility.Account.withdraw
                }
                .frame(width: 100)
                .padding(.trailing, 16)
            }
            HStack {
                Spacer()
                TextField("Deposit", text: $amountToDeposit)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                    .padding(.bottom, 32)
                Button("Deposit") {
                    viewModel.deposit(amountString: amountToDeposit)
                }
                .introspect(.view, on: .iOS(.v17)) {
                    $0.accessibilityIdentifier = Accessibility.Account.deposit
                }
                .frame(width: 100)
                .padding(.trailing, 16)
                .padding(.bottom, 32)
            }
        }
    }
}
