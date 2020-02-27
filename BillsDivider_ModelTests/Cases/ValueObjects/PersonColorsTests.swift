@testable import BillsDivider_Model
import XCTest

class PersonColorsTests: XCTestCase {
    func testDefault_returnsPersonsColorsWithGreenBackgroungAndWhiteForeground() {
        let sut: PersonColors = .fromColor(.black)
        XCTAssertEqual(sut.background, .green)
        XCTAssertEqual(sut.foreground, .white)
    }

    func testFromColor_withWhiteColor_returnsPersonsColorsWithWhiteBackgroungAndBlackForeground() {
        let sut: PersonColors = .fromColor(.white)
        XCTAssertEqual(sut.background, .white)
        XCTAssertEqual(sut.foreground, .black)
    }

    func testFromColor_withBlueColor_returnsPersonsColorsWithBlueBackgroundAndWhiteForeground() {
        let sut: PersonColors = .fromColor(.blue)
        XCTAssertEqual(sut.background, .blue)
        XCTAssertEqual(sut.foreground, .white)
    }

    func testFromColor_withGreenColor_returnsPersonsColorsWithGreenBackgroundAndWhiteForeground() {
        let sut: PersonColors = .fromColor(.green)
        XCTAssertEqual(sut.background, .green)
        XCTAssertEqual(sut.foreground, .white)
    }

    func testFromColor_withPurpleColor_returnsPersonsColorsWithPurpleBackgroundAndWhiteForeground() {
        let sut: PersonColors = .fromColor(.purple)
        XCTAssertEqual(sut.background, .purple)
        XCTAssertEqual(sut.foreground, .white)
    }

    func testFromColor_withPinkColor_returnsPersonsColorsWithPinkBackgroundAndWhiteForeground() {
        let sut: PersonColors = .fromColor(.pink)
        XCTAssertEqual(sut.background, .pink)
        XCTAssertEqual(sut.foreground, .white)
    }

    func testFromColor_withRedColor_returnsPersonsColorsWithRedBackgroundAndWhiteForeground() {
        let sut: PersonColors = .fromColor(.red)
        XCTAssertEqual(sut.background, .red)
        XCTAssertEqual(sut.foreground, .white)
    }

    func testFromColor_withOrangeColor_returnsPersonsColorsWithOrangeBackgroundAndWhiteForeground() {
        let sut: PersonColors = .fromColor(.orange)
        XCTAssertEqual(sut.background, .orange)
        XCTAssertEqual(sut.foreground, .white)
    }

    func testEquals_withTheSameColors_returnsTrue() {
        XCTAssertTrue(PersonColors.fromColor(.orange) == PersonColors.fromColor(.orange))
    }

    func testEquals_withDifferentColors_returnsFalse() {
        XCTAssertFalse(PersonColors.fromColor(.orange) == PersonColors.fromColor(.blue))
    }
}
