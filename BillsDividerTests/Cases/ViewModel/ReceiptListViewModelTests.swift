@testable import BillsDivider
import Combine
import XCTest

class ReceiptListViewModelTests: XCTestCase {
    private var sut: ReceiptListViewModel!
    private var receiptPositionService: ReceiptPositionService!

    private var numberFormatter: NumberFormatter {
        .twoFractionDigitsNumberFormatter
    }

    override func setUp() {
        super.setUp()
        receiptPositionService = InMemoryReceiptPositionService()
        sut = .init(receiptPositionService: receiptPositionService, numberFormatter: numberFormatter)
    }

    override func tearDown() {
        sut = nil
        receiptPositionService = nil
        super.tearDown()
    }

    func testInit_whenNoPositionsArePersisted_positionsAreEmpty() {
        XCTAssertTrue(sut.positions.isEmpty)
    }

    func testInit_whenPositionsArePersisted_setsThosePositions() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .me, owner: .notMe),
            .init(amount: 2, buyer: .notMe, owner: .me)
        ]
        receiptPositionService.set(positions)

        sut = .init(receiptPositionService: receiptPositionService, numberFormatter: numberFormatter)

        XCTAssertEqual(sut.positions.count, 2)
        XCTAssertEqual(sut.positions[0], positions[0])
        XCTAssertEqual(sut.positions[1], positions[1])
    }

    func testRemoveAllPositions_positionsAreEmpty() {
        sut.positions.append(ReceiptPosition(amount: 1, buyer: .me, owner: .notMe))
        XCTAssertFalse(sut.positions.isEmpty)

        sut.removeAllPositions()
        XCTAssertTrue(sut.positions.isEmpty)
    }

    func testObject_whenSubscribedPublisherEmitsPositions_positionsIsInsertedToPositionsList() {
        let publisher = PassthroughSubject<ReceiptPosition, Never>()
        let emptyPublisher = Empty<ReceiptPosition, Never>()
        sut.subscribe(
            addingPublisher: publisher.eraseToAnyPublisher(),
            editingPublisher: emptyPublisher.eraseToAnyPublisher()
        )

        let position1 = ReceiptPosition(amount: 1, buyer: .me, owner: .notMe)
        publisher.send(position1)

        let position2 = ReceiptPosition(amount: 2, buyer: .notMe, owner: .me)
        publisher.send(position2)

        XCTAssertEqual(position1, sut.positions[1])
        XCTAssertEqual(position2, sut.positions[0])
    }

    func testRemovePositionAtIndex_removePositionAtGivenIndex() {
        let publisher = PassthroughSubject<ReceiptPosition, Never>()
        let emptyPublisher = Empty<ReceiptPosition, Never>()
        sut.subscribe(
            addingPublisher: publisher.eraseToAnyPublisher(),
            editingPublisher: emptyPublisher.eraseToAnyPublisher()
        )

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
        let numberFormatter: NumberFormatter = .twoFractionDigitsNumberFormatter
        XCTAssertEqual(sut.formatNumber(value: 1), numberFormatter.format(value: 1))
    }
}
