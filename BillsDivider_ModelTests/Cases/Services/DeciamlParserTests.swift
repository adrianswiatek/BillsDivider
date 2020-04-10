import BillsDivider_Model
import XCTest

class DeciamlParserTests: XCTestCase {
    private var sut: DecimalParser!

    override func setUp() {
        super.setUp()
        sut = DecimalParser()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testTryParse_whenValueIsInvalid_returnsNil() {
        XCTAssertNil(sut.tryParse("abc"))
        XCTAssertNil(sut.tryParse("-"))
        XCTAssertNil(sut.tryParse("-1"))
    }

    func testTryParse_whenValueIsValid_returnsParsedValue() {
        XCTAssertEqual(sut.tryParse("1.23"), 1.23)
        XCTAssertEqual(sut.tryParse("1,23"), 1.23)
    }

    func testParse_whenValueIsValid_returnsResultWithParsedValue() {
        let expected = Result<Decimal, DecimalParser.DecimalParseError>.success(1.23)
        let actual = sut.parse("1.23")
        XCTAssertEqual(actual, expected)
    }

    func testParse_whenValueHasMoreThanTwoDigitsAfterDot_returnsResultWithWrongFormatError() {
        let expected = Result<Decimal, DecimalParser.DecimalParseError>.failure(.wrongFormat)
        let actual = sut.parse("1.234")
        XCTAssertEqual(actual, expected)
    }

    func testParse_whenValueHasInvalidCharacter_returnsResultWithWrongFormatError() {
        let expected = Result<Decimal, DecimalParser.DecimalParseError>.failure(.wrongFormat)
        let actual = sut.parse("abc")
        XCTAssertEqual(actual, expected)
    }

    func testParse_whenValueHasMoreThanFiveDigitsBeforeDow_returnsResultWithExceededMaximumValueError() {
        let expected = Result<Decimal, DecimalParser.DecimalParseError>.failure(.exceededMaximumValue)
        let actual = sut.parse("123456.12")
        XCTAssertEqual(actual, expected)
    }
}
