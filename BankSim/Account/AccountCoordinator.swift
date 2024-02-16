//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import SwiftUI

class AccountCoordinator: Coordinator, ObservableObject {
    var navigationController: UINavigationController
    var parent: (any Coordinator)?
    var children: [any Coordinator] = []

    let viewModel: AccountViewModel

    init(
        navigationController: UINavigationController,
        viewModel: AccountViewModel
    ) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }

    @ViewBuilder
    func start() -> some View {
        AccountView(coordinator: self, viewModel: self.viewModel)
    }

    func dismiss() {
        parent?.childDidDismiss(self)
    }
}
