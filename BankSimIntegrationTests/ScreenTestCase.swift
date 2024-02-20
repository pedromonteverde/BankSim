//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import UIKit
import XCTest
@testable import BankSim

class ScreenTestCase: XCTestCase {

    static let timeout: Double = 10
    var exp: XCTestExpectation?
    var screenPresented: (() -> Void)?

    override func setUp() {
        Database.reset()
        exp = expectation(description: "ScreenTestCase")
    }

    override func tearDown() {
        navigationController?.viewControllers.removeAll()
    }

    var navigationController: UINavigationController? {
        let navigation = SceneDelegate.navigationController
        navigation?.delegate = self
        return navigation

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

    func wait(for time: UInt32) async -> Self {
        sleep(time)
        return self
    }

    func fulfill() async {
        exp?.fulfill()
        await fulfillment(of: [exp].compactMap {$0}, timeout: Self.timeout)
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
