//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import UIKit

extension UIView {

    func subviewsRecursive() -> [UIView] {
        subviews + subviews.flatMap { $0.subviewsRecursive() }
    }
}
