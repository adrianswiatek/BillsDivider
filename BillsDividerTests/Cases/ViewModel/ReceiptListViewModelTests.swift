@testable import BillsDivider
import Combine
import XCTest

class ReceiptListViewModelTests: XCTestCase {
    private var sut: ReceiptListViewModel!

    override func setUp() {
        super.setUp()
        sut = .init(numberFormatter: .twoFracionDigitsNumberFormatter)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testInit_positionsAreEmpty() {
        XCTAssertTrue(sut.positions.isEmpty)
    }

    func testRemoveAllPositions_positionsAreEmpty() {
        sut.positions.append(ReceiptPosition(amount: 1, buyer: .me, owner: .notMe))
        XCTAssertFalse(sut.positions.isEmpty)

        sut.removeAllPositions()
        XCTAssertTrue(sut.positions.isEmpty)
    }

    func testObject_whenSubscribedPublisherEmitsPositions_positionsIsInsertedToPositionsList() {
        let publisher = PassthroughSubject<ReceiptPosition, Never>()
        sut.subscribe(to: publisher.eraseToAnyPublisher())

        let position1 = ReceiptPosition(amount: 1, buyer: .me, owner: .notMe)
        publisher.send(position1)

        let position2 = ReceiptPosition(amount: 2, buyer: .notMe, owner: .me)
        publisher.send(position2)

        XCTAssertEqual(position1, sut.positions[1])
        XCTAssertEqual(position2, sut.positions[0])
    }

    func testRemovePositionAtIndex_removePositionAtGivenIndex() {
        let publisher = PassthroughSubject<ReceiptPosition, Never>()
        sut.subscribe(to: publisher.eraseToAnyPublisher())

        let positionAtIndex2 = ReceiptPosition(amount: 2, buyer: .me, owner: .notMe)
        publisher.send(positionAtIndex2)

        let positionAtIndex1 = ReceiptPosition(amount: 1, buyer: .me, owner: .notMe)
        publisher.send(positionAtIndex1)

        let positionAtIndex0 = ReceiptPosition(amount: 0, buyer: .me, owner: .notMe)
        publisher.send(positionAtIndex0)

        sut.removePosition(at: 1)

        XCTAssertEqual(sut.positions[0], positionAtIndex0)
        XCTAssertEqual(sut.positions[1], positionAtIndex2)
    }

    func testFormatNumber_returnsFormattedValue() {
        let numberFormatter: NumberFormatter = .twoFracionDigitsNumberFormatter
        XCTAssertEqual(sut.formatNumber(value: 1), numberFormatter.format(value: 1))
    }
}
