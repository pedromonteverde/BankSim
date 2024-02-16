//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import SwiftUI

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
                .frame(width: 100)
                .padding(.trailing, 16)
                .padding(.bottom, 32)
            }
        }
    }
}
