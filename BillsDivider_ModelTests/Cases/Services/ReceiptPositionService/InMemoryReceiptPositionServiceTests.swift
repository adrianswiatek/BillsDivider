@testable import BillsDivider_Model
import Combine
import XCTest

class InMemoryReceiptPositionServiceTests: XCTestCase {
    private var sut: ReceiptPositionService!
    private var peopleService: PeopleService!
    private var subscriptions: [AnyCancellable]!

    override func setUp() {
        super.setUp()
        peopleService = InMemoryPeopleService(maximumNumberOfPeople: 2)
        sut = InMemoryReceiptPositionService(peopleService: peopleService)
        subscriptions = []
    }

    override func tearDown() {
        subscriptions = nil
        sut = nil
        peopleService = nil
        super.tearDown()
    }

    func testPositionsDidUpdate_whenEmptyPositions_sendsEmptyArray() {
        var result: [ReceiptPosition]?
        let expectation = self.expectation(description: "Receipt positions are sent")
        sut.positionsDidUpdate
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(result, [])
    }

    func testInsertPosition_insertsGivenPosition() {
        let position = ReceiptPosition(amount: 1, buyer: .person(.withName("My name")), owner: .all)
        sut.insert(position)
        XCTAssertEqual(sut.fetchPositions(), [position])
    }

    func testInsertPosition_twoTimes_insertTwoGivenPositions() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(.withGeneratedName(forNumber: 1)), owner: .all),
            .init(amount: 2, buyer: .person(.withGeneratedName(forNumber: 2)), owner: .all)
        ]
        positions.forEach { sut.insert($0) }
        XCTAssertEqual(sut.fetchPositions(), positions.reversed())
    }

    func testUpdatePosition_updatesGivenPosition() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(.withGeneratedName(forNumber: 1)), owner: .all),
            .init(amount: 2, buyer: .person(.withGeneratedName(forNumber: 2)), owner: .all)
        ]
        positions.forEach { sut.insert($0) }

        let updatedPosition = ReceiptPosition(
            id: positions[1].id,
            amount: 3,
            buyer: .person(.withGeneratedName(forNumber: 1)),
            owner: .person(.withGeneratedName(forNumber: 2))
        )

        sut.update(updatedPosition)

        XCTAssertEqual(sut.fetchPositions(), [updatedPosition, positions[0]])
    }

    func testRemovePosition_removesGivenPosition() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(.withGeneratedName(forNumber: 1)), owner: .all),
            .init(amount: 2, buyer: .person(.withGeneratedName(forNumber: 2)), owner: .all)
        ]
        positions.forEach { sut.insert($0) }

        sut.remove(positions[1])

        XCTAssertEqual(sut.fetchPositions(), [positions[0]])
    }

    func testRemoveAllPositions_removesAllPositions() {
        let position1 = ReceiptPosition(amount: 1, buyer: .person(.withName("First")), owner: .all)
        sut.insert(position1)

        let position2 = ReceiptPosition(amount: 2, buyer: .person(.withName("Second")), owner: .all)
        sut.insert(position2)

        sut.removeAllPositions()

        XCTAssertEqual(sut.fetchPositions(), [])
    }

    func testFetchPositions_whenNoPositions_returnsEmptyArray() {
        XCTAssertEqual(sut.fetchPositions(), [])
    }

    func testFetchPositions_whenOnePositionAdded_returnsGivenPosition() {
        let position = ReceiptPosition(amount: 1, buyer: .person(.withName("My name")), owner: .all)
        sut.insert(position)
        XCTAssertEqual(sut.fetchPositions(), [position])
    }

    func testFetchPositions_whenTwoPositionsAdded_returnsTwoGivenPositions() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(.withGeneratedName(forNumber: 1)), owner: .all),
            .init(amount: 2, buyer: .person(.withGeneratedName(forNumber: 2)), owner: .all)
        ]
        positions.forEach { sut.insert($0) }
        XCTAssertEqual(sut.fetchPositions(), positions.reversed())
    }

    func test_whenPeopleServiceUpdatesPeoples_sendsPositionsThroughPositionsDidUpdate() {
        let originalPerson: Person = .withName("Original name")
        let originalPosition = ReceiptPosition(amount: 0, buyer: .person(originalPerson), owner: .all)
        sut.insert(originalPosition)

        var result: [ReceiptPosition] = []
        let expectation = self.expectation(description: "Receipt Position is sent")
        sut.positionsDidUpdate
            .dropFirst()
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        let updatedPerson: Person = originalPerson.withUpdated(name: "Updated name")
        peopleService.updatePeople(.fromPerson(updatedPerson))

        let expectedPosition = ReceiptPosition(
            amount: originalPosition.amount,
            buyer: .person(updatedPerson),
            owner: .all
        )

        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(result, [expectedPosition])
    }
}
