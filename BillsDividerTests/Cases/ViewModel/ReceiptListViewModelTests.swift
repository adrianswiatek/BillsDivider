@testable import BillsDivider
import Combine
import XCTest

class ReceiptListViewModelTests: XCTestCase {
    private var sut: ReceiptViewModel!
    private var receiptPositionService: ReceiptPositionService!
    private var peopleService: PeopleService!

    private var numberFormatter: NumberFormatter {
        .twoFractionDigitsNumberFormatter
    }

    override func setUp() {
        super.setUp()
        peopleService = PeopleServiceFake()
        receiptPositionService = InMemoryReceiptPositionService(peopleService: peopleService)
        sut = .init(receiptPositionService: receiptPositionService, numberFormatter: numberFormatter)
    }

    override func tearDown() {
        sut = nil
        peopleService = nil
        receiptPositionService = nil
        super.tearDown()
    }

    func testInit_whenNoPositionsArePersisted_positionsAreEmpty() {
        XCTAssertTrue(sut.positions.isEmpty)
    }

    func testInit_whenPositionsArePersisted_setsThosePositions() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(.withName("1")), owner: .person(.withName("2"))),
            .init(amount: 2, buyer: .person(.withName("2")), owner: .person(.withName("1")))
        ]
        positions.forEach { receiptPositionService.insert($0) }

        sut = .init(receiptPositionService: receiptPositionService, numberFormatter: numberFormatter)

        XCTAssertEqual(sut.positions.count, 2)
        XCTAssertEqual(sut.positions[0], positions[0])
        XCTAssertEqual(sut.positions[1], positions[1])
    }

    func testRemoveAllPositions_positionsAreEmpty() {
        let position = ReceiptPosition(amount: 1, buyer: .person(.withName("1")), owner: .person(.withName("2")))

        sut.positions.append(position)
        XCTAssertFalse(sut.positions.isEmpty)

        sut.removeAllPositions()
        XCTAssertTrue(sut.positions.isEmpty)
    }

    func test_whenSubscribedPublisherEmitsAddedPositions_positionsIsInsertedToPositionsList() {
        let addingPublisher = PassthroughSubject<ReceiptPosition, Never>()
        let emptyPublisher = Empty<ReceiptPosition, Never>()
        sut.subscribe(
            addingPublisher: addingPublisher.eraseToAnyPublisher(),
            editingPublisher: emptyPublisher.eraseToAnyPublisher()
        )

        let position1 = ReceiptPosition(amount: 1, buyer: .person(.withName("1")), owner: .person(.withName("2")))
        addingPublisher.send(position1)

        let position2 = ReceiptPosition(amount: 2, buyer: .person(.withName("2")), owner: .person(.withName("1")))
        addingPublisher.send(position2)

        XCTAssertEqual(sut.positions[1], position1)
        XCTAssertEqual(sut.positions[0], position2)
    }

    func test_whenSubscribedPublisherEmitsEditedPosition_positionIsUpdatedInPositionsList() {
        let firstPerson: Person = .withGeneratedName(forNumber: 1)
        let secondPerson: Person = .withGeneratedName(forNumber: 2)

        let addingPublisher = PassthroughSubject<ReceiptPosition, Never>()
        let editingPublisher = PassthroughSubject<ReceiptPosition, Never>()
        sut.subscribe(
            addingPublisher: addingPublisher.eraseToAnyPublisher(),
            editingPublisher: editingPublisher.eraseToAnyPublisher()
        )

        let addedPosition = ReceiptPosition(amount: 1, buyer: .person(firstPerson), owner: .person(secondPerson))
        addingPublisher.send(addedPosition)

        let editedPosition = ReceiptPosition(id: addedPosition.id, amount: 2, buyer: .person(secondPerson), owner: .all)
        editingPublisher.send(editedPosition)

        XCTAssertEqual(sut.positions.first?.id, editedPosition.id)
        XCTAssertEqual(sut.positions.first?.amount, editedPosition.amount)
        XCTAssertEqual(sut.positions.first?.buyer, editedPosition.buyer)
        XCTAssertEqual(sut.positions.first?.owner, editedPosition.owner)
    }

    func testRemovePositionAtIndex_removesPositionAtGivenIndex() {
        let buyer: Buyer = .person(.withGeneratedName(forNumber: 1))
        let owner: Owner = .person(.withGeneratedName(forNumber: 2))
        let addingPublisher = PassthroughSubject<ReceiptPosition, Never>()
        let emptyPublisher = Empty<ReceiptPosition, Never>()
        sut.subscribe(
            addingPublisher: addingPublisher.eraseToAnyPublisher(),
            editingPublisher: emptyPublisher.eraseToAnyPublisher()
        )

        let positionAtIndex2 = ReceiptPosition(amount: 2, buyer: buyer, owner: owner)
        addingPublisher.send(positionAtIndex2)

        let positionAtIndex1 = ReceiptPosition(amount: 1, buyer: buyer, owner: owner)
        addingPublisher.send(positionAtIndex1)

        let positionAtIndex0 = ReceiptPosition(amount: 0, buyer: buyer, owner: owner)
        addingPublisher.send(positionAtIndex0)

        sut.removePosition(at: 1)

        XCTAssertEqual(sut.positions[0], positionAtIndex0)
        XCTAssertEqual(sut.positions[1], positionAtIndex2)
    }

    func testRemovePosition_removesGivenPosition() {
        let buyer: Buyer = .person(.withGeneratedName(forNumber: 1))
        let owner: Owner = .person(.withGeneratedName(forNumber: 2))
        let addingPublisher = PassthroughSubject<ReceiptPosition, Never>()
        let emptyPublisher = Empty<ReceiptPosition, Never>()
        sut.subscribe(
            addingPublisher: addingPublisher.eraseToAnyPublisher(),
            editingPublisher: emptyPublisher.eraseToAnyPublisher()
        )

        let position3 = ReceiptPosition(amount: 3, buyer: buyer, owner: owner)
        addingPublisher.send(position3)

        let position2 = ReceiptPosition(amount: 2, buyer: buyer, owner: owner)
        addingPublisher.send(position2)

        let position1 = ReceiptPosition(amount: 1, buyer: buyer, owner: owner)
        addingPublisher.send(position1)

        sut.removePosition(position2)

        XCTAssertEqual(sut.positions[0], position1)
        XCTAssertEqual(sut.positions[1], position3)
    }

    func testFormatNumber_returnsFormattedValue() {
        let numberFormatter: NumberFormatter = .twoFractionDigitsNumberFormatter
        XCTAssertEqual(sut.formatNumber(value: 1), numberFormatter.format(value: 1))
    }
}
