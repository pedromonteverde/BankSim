//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import SwiftUI

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }

    var parent: Coordinator? { get set }
    var children: [Coordinator] { get set }

    func start()

    func childDidDismiss(_ child: Coordinator)
}

extension Coordinator {
    func childDidDismiss(_ child: Coordinator) {
        children.removeAll { $0 === child }
    }
}
