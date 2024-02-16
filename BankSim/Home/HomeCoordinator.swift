//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import SwiftUI

class HomeCoordinator: Coordinator, ObservableObject {
    var navigationController: UINavigationController
    var parent: (any Coordinator)?
    var children: [any Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    @ViewBuilder
    func start() -> some View {
        NavigationView {
            HomeView(
                coordinator: self,
                viewModel: HomeViewModel()
            )
        }
    }

    func goToAccount(_ accountRequest: AccountRequest) -> some View {
        let viewModel = AccountViewModel(accountRequest: accountRequest)
        let coordinator = AccountCoordinator(navigationController: navigationController, viewModel: viewModel)
        coordinator.parent = self
        children.append(coordinator)
        return coordinator.start()
    }
}
