//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import SwiftUI

struct AccountView: View {

    var coordinator: AccountCoordinator
    @StateObject var viewModel: AccountViewModel

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                AccountHeaderView(viewModel: viewModel)
                Spacer(minLength: 16)
                ZStack {
                    List {
                        ForEach(
                            viewModel.transactions.sorted { $0.date > $1.date },
                            id: \.id
                        ) {
                            TransactionCellView(transaction: $0)
                        }
                    }
                    .animation(.default, value: viewModel.transactions.count)
                    if viewModel.transactions.isEmpty {
                        Text("No Transactions")
                            .foregroundStyle(Color.gray)
                    }
                }
            }
            .padding()
            TransferView(viewModel: viewModel)
        }
        .navigationBarTitle("Account Details")
        .errorAlert(error: $viewModel.error)
        .onAppear {
            viewModel.fetch()
        }
        .onDisappear {
            coordinator.dismiss()
        }
    }
}

#Preview {
    AccountCoordinator(
        navigationController: DummyNavigationController(),
        viewModel: AccountViewModel(accountRequest: Database.account.id)
    ).start()
}

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: date)
}
