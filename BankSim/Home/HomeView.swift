//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import SwiftUI
import SwiftUIIntrospect

struct HomeView: View {

    var coordinator: HomeCoordinator
    @StateObject var viewModel: HomeViewModel

    var body: some View {
        VStack(alignment: .leading) {
            UserDetailsView(viewModel: viewModel)
                .introspect(.view, on: .iOS(.v17)) {
                    $0.accessibilityIdentifier = Accessibility.Home.header
                }
            List {
                ForEach(viewModel.accounts, id: \.id) { account in
                    AccountCellView(accountType: account.type, accountBalance: account.balance)
                        .introspect(.listCell, on: .iOS(.v17)) {
                            $0.accessibilityIdentifier = Accessibility.Home.cell
                        }
                        .onTapGesture {
                            coordinator.goToAccount(account.id)
                        }
                }
            }
            .introspect(.list, on: .iOS(.v17)) {
                $0.accessibilityIdentifier = Accessibility.Home.list
            }
        }
        .padding()
        .navigationBarTitle("Accounts")
        .errorAlert(error: $viewModel.error)
        .onAppear {
            viewModel.fetch()
        }
    }
}

#Preview {
    HomeView(
        coordinator: HomeCoordinator(
            navigationController: DummyNavigationController()
        ),
        viewModel: HomeViewModel()
    )
}
