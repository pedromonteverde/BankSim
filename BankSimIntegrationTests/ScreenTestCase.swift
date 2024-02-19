//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import UIKit
import XCTest
@testable import BankSim

class ScreenTestCase: XCTestCase {

    override func tearDown() {
        navigationController?.viewControllers.removeAll()
        Database.account.transactions.removeAll()
    }

    var navigationController: UINavigationController? {
        let navigation = SceneDelegate.navigationController
        navigation?.delegate = self
        return navigation

    }
    var screenPresented: (() -> Void)?

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

    func wait(for time: UInt32) async -> Self {
        sleep(time)
        return self
    }

    func fulfill(_ expectaction: XCTestExpectation) {
        expectaction.fulfill()
    }
}

extension ScreenTestCase: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        DispatchQueue.main.async {
            self.screenPresented?()
        }
    }

    @discardableResult
    func waitForPresentation() async -> Self {
        await withCheckedContinuation { continuation in
            screenPresented = {
                continuation.resume()
            }
        }
        screenPresented = nil
        return self
    }
}
