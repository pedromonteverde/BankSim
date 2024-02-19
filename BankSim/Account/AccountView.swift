//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import SwiftUI
import SwiftUIIntrospect

struct AccountView: View {

    var coordinator: AccountCoordinator
    @StateObject var viewModel: AccountViewModel

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                AccountHeaderView(viewModel: viewModel)
                    .introspect(.view, on: .iOS(.v17)) {
                        $0.accessibilityIdentifier = Accessibility.Account.header
                    }
                Spacer(minLength: 16)
                ZStack {
                    List {
                        ForEach(
                            viewModel.transactions.sorted { $0.date > $1.date },
                            id: \.id
                        ) {
                            TransactionCellView(transaction: $0)
                                .introspect(.listCell, on: .iOS(.v17)) {
                                    $0.accessibilityIdentifier = Accessibility.Account.cell
                                }
                        }
                    }
                    .animation(.default, value: viewModel.transactions.count)
                    .introspect(.list, on: .iOS(.v17)) {
                        $0.accessibilityIdentifier = Accessibility.Account.list
                    }
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
    let viewModel = AccountViewModel(accountRequest: Database.account.id)
    return AccountView(
        coordinator: AccountCoordinator(
            navigationController: DummyNavigationController(),
            viewModel: viewModel
        ),
        viewModel: viewModel
    )
}

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: date)
}
