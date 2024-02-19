//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import SwiftUI

class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parent: Coordinator?
    var children: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let swiftUIView = HomeView(coordinator: self, viewModel: HomeViewModel())
        let viewController = UIHostingController(rootView: swiftUIView)
        navigationController.pushViewController(viewController, animated: false)
    }

    func goToAccount(_ accountRequest: AccountRequest) {
        let viewModel = AccountViewModel(accountRequest: accountRequest)
        let coordinator = AccountCoordinator(navigationController: navigationController, viewModel: viewModel)
        coordinator.parent = self
        children.append(coordinator)
        coordinator.start()
    }
}
