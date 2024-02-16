//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import XCTest
@testable import BankSim

final class ValidatorTests: XCTestCase {

    var repository: Repository?

    override func setUpWithError() throws {
//        repository = MockRepository()
    }

    override func tearDownWithError() throws {
        repository = nil
    }

    func testFecthDogImages_givenInvalidURL_ThrowError() throws {

    }

    func testFecthDogImages_givenInvalidCodables_ThrowError() throws {

    }

    func testFecthDogImages_givenValidRequest_RetrieveDogImages() throws {

    }
}
