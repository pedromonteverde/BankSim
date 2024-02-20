//
//  Copyright © 2024 Pedro Monteverde. All rights reserved.
//

import XCTest
@testable import BankSim

final class ValidatorTests: XCTestCase {

    var sut: Validating!

    override func setUp() {
        sut = Validator()
    }

    override func tearDown() {
        sut = nil
    }


    func testValidator_givenInvalidInputAmount_ThrowInvalidAmountError() {
        let input = "dsdadsdads"
        XCTAssertThrowsError(try sut.validate(input)) { error in
            do {
                switch try XCTUnwrap(error as? ValidationError) {
                case .invalidAmount:
                    XCTAssertTrue(true)
                case .notPositiveAmount:
                    XCTFail()
                }
            } catch {
                XCTFail()
            }
        }

    }
    func testValidator_giveNegativeInputAmount_ThrownoPositiveAmountError() {
        let input = "-12818289"
        XCTAssertThrowsError(try sut.validate(input)) { error in
            do {
                switch try XCTUnwrap(error as? ValidationError) {
                case .invalidAmount:
                    XCTFail()
                case .notPositiveAmount:
                    XCTAssertTrue(true)
                }
            } catch {
                XCTFail()
            }
        }

    }

    func testValidator_givenValidInputAmount_ReturnRightAmount() throws {
        let input = "212121"
        let amount = try sut.validate("212121")
        XCTAssertEqual(amount, 212121)
    }
}
