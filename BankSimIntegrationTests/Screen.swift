//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import UIKit
@testable import BankSim

protocol Screen {
    var navigationController: UINavigationController? { get }
}

extension Screen {

    var navigationController: UINavigationController? {
        SceneDelegate.navigationController
    }

    func find(by accessibilityIdentifier: String) -> UIView? {
        navigationController?
            .topViewController?
            .view
            .subviewsRecursive()
            .first { $0.accessibilityIdentifier == accessibilityIdentifier }
    }

    func filter(by accessibilityIdentifier: String) -> [UIView]? {
        navigationController?
            .topViewController?
            .view
            .subviewsRecursive()
            .filter { $0.accessibilityIdentifier == accessibilityIdentifier }
    }

    func andWait(for time: UInt32) async -> Self {
        sleep(time)
        return self
    }
}
