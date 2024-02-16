//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import SwiftUI

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }

    associatedtype V: View

    var parent: (any Coordinator)? { get set }
    var children: [any Coordinator] { get set }

    @ViewBuilder
    func start() -> V

    func childDidDismiss(_ child: any Coordinator)
}

extension Coordinator {
    func childDidDismiss(_ child: any Coordinator) {
        children.removeAll { $0 === child }
    }
}
