//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import Foundation

protocol Validating {
    func validate(_ value: String) throws -> Amount
}

struct Validator: Validating {

    func validate(_ value: String) throws -> Amount {
        guard let valid = Amount(value) else {
            throw ValidationError.invalidAmount
        }
        guard valid > 0 else {
            throw ValidationError.notPositiveAmount
        }
        return valid
    }
}
