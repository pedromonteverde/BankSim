//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import SwiftUI
import Combine

class AccountCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parent: Coordinator?
    var children: [Coordinator] = []

    let viewModel: AccountViewModel

    init(
        navigationController: UINavigationController,
        viewModel: AccountViewModel
    ) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }

    func start() {
        let swiftUIView = AccountView(coordinator: self, viewModel: self.viewModel)
        let viewController = UIHostingController(rootView: swiftUIView)
        navigationController.pushViewController(viewController, animated: true)
    }

    func dismiss() {
        parent?.childDidDismiss(self)
    }
}
