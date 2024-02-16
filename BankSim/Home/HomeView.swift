//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import SwiftUI
import Combine

struct HomeView: View {

    var coordinator: HomeCoordinator
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            UserDetailsView(viewModel: viewModel)
            List {
                ForEach(viewModel.accounts, id: \.id) { account in
                    // Redo this
                    NavigationLink(
                        destination: coordinator.goToAccount(account.id)
                    ) {
                        AccountCellView(accountType: account.type, accountBalance: account.balance)
                    }
                }
            }
            .accessibilityIdentifier(Accessibility.Home.account)
        }
        .accessibilityIdentifier(Accessibility.Home.account)
        .accessibilityLabel("Test")
        .padding()
        .navigationBarTitle("Accounts")
        .errorAlert(error: $viewModel.error)
        .onAppear {
            viewModel.fetch()
        }
    }
}

#Preview {
    HomeCoordinator(navigationController: DummyNavigationController()).start()
}
