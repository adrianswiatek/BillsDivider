@testable import BillsDivider_Model
import XCTest

class SumResultTests: XCTestCase {
    func testAmount_zeroCase_returnsZero() {
        let sut: SumResult = .zero
        XCTAssertEqual(sut.amount, 0)
    }

    func testAmount_valueCase_returnsGivenAmount() {
        let sut: SumResult = .value(amount: 123.45)
        XCTAssertEqual(sut.amount, 123.45)
    }

    func testFrom_withEmptyArray_returnsSumResultAsZeroCase() {
        let sut: SumResult = .from(values: [])
        XCTAssertEqual(sut, .zero)
    }

    func testFrom_withTwoZeros_returnsSumResultAsZeroCase() {
        let sut: SumResult = .from(values: [0, 0])
        XCTAssertEqual(sut, .zero)
    }

    func testFrom_withOneValue_returnsSumResultAsValueCaseWithGivenValue() {
        let sut: SumResult = .from(values: [1])
        XCTAssertEqual(sut, .value(amount: 1))
    }

    func testFrom_withTwoValues_returnsSumResultAsValueCaseWithSumOfGivenValues() {
        let sut: SumResult = .from(values: [1, 2])
        XCTAssertEqual(sut, .value(amount: 3))
    }

    func testFrom_withOneNegativeValue_returnsSumResultAsZero() {
        let sut: SumResult = .from(values: [-1])
        XCTAssertEqual(sut, .zero)
    }
}
