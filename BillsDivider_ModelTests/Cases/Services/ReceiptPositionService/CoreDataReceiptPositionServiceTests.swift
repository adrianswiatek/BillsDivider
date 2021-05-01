@testable import BillsDivider_Model
import Combine
import CoreData
import XCTest

class CoreDataReceiptPositionServiceTests: XCTestCase {
    private var sut: CoreDataReceiptPositionService!
    private var context: NSManagedObjectContext!
    private var peopleService: PeopleService!
    private var people: People!
    private var subscriptions: [AnyCancellable]!

    private var firstPerson: Person {
        people[0]
    }

    private var secondPerson: Person {
        people[1]
    }

    override func setUp() {
        super.setUp()
        people = .fromArray([.withGeneratedName(forNumber: 1), .withGeneratedName(forNumber: 2)])
        peopleService = InMemoryPeopleService(maximumNumberOfPeople: 2)
        peopleService.updatePeople(people)
        context = InMemoryCoreDataStack().context
        sut = CoreDataReceiptPositionService(context, peopleService)
        subscriptions = []
    }

    override func tearDown() {
        subscriptions = nil
        sut = nil
        context = nil
        peopleService = nil
        people = nil
        super.tearDown()
    }

    func testInsertPositions_withPosition_saveMethodHasBeenCalled() {
        let position = ReceiptPosition(amount: 1, buyer: .person(.empty), owner: .all)
        let expectation = XCTNSNotificationExpectation(name: .NSManagedObjectContextDidSave)

        sut.insert(position)

        wait(for: [expectation], timeout: 0.3)
    }

    func testInsertPositions_withPosition_oneItemIsPersisted() {
        let position = ReceiptPosition(amount: 1, buyer: .person(firstPerson), owner: .all)
        sut.insert(position)

        XCTAssertEqual(sut.fetchAll(), [position])
    }

    func testInsertPositions_withPosition_sendsPositionThroughPositionsDidUpdate() {
        var result: [ReceiptPosition]?
        let expectation = self.expectation(description: "Receipt positions are sent")
        sut.positionsDidUpdate
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        let position = ReceiptPosition(amount: 1, buyer: .person(firstPerson), owner: .all)
        sut.insert(position)

        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(result, [position])
    }

    func testInsertPositions_withTwoPositions_sendsPositionThroughPositionsDidUpdate() {
        var result: [ReceiptPosition]?
        let expectation = self.expectation(description: "Receipt positions are sent")
        expectation.expectedFulfillmentCount = 2
        sut.positionsDidUpdate
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .all),
            .init(amount: 2, buyer: .person(secondPerson), owner: .all)
        ]
        positions.forEach { sut.insert($0) }

        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(result, positions.reversed())
    }

    func testRemovePosition_whenOnePositionPersisted_removesGivenPosition() {
        let position = ReceiptPosition(amount: 1, buyer: .person(firstPerson), owner: .all)
        sut.insert(position)

        sut.remove(position)

        XCTAssertEqual(sut.fetchAll(), [])
    }

    func testRemovePosition_whenTwoPositionsPersisted_removesGivenPosition() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .all),
            .init(amount: 2, buyer: .person(secondPerson), owner: .all)
        ]
        positions.forEach { sut.insert($0) }

        sut.remove(positions[0])

        XCTAssertEqual(sut.fetchAll(), [positions[1]])
    }

    func testRemovePosition_whenOnePositionPersisted_sendsEmptyArrayThroughPositionsDidUpdate() {
        let position = ReceiptPosition(amount: 1, buyer: .person(firstPerson), owner: .all)
        sut.insert(position)

        var result: [ReceiptPosition]?
        let expectation = self.expectation(description: "Receipt Positions are sent")
        sut.positionsDidUpdate
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        sut.remove(position)

        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(result, [])
    }

    func testUpdatePosition_updatesGivenPosition() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .all),
            .init(amount: 2, buyer: .person(secondPerson), owner: .all)
        ]
        positions.forEach { sut.insert($0) }

        let updatedPosition = ReceiptPosition(
            id: positions[1].id,
            amount: 3,
            buyer: .person(firstPerson),
            owner: .person(secondPerson)
        )

        sut.update(updatedPosition)

        XCTAssertEqual(sut.fetchAll(), [updatedPosition, positions[0]])
    }

    func testUpdatePosition_sendsPositionthroughPositionsDidUpdate() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .all),
            .init(amount: 2, buyer: .person(secondPerson), owner: .all)
        ]
        positions.forEach { sut.insert($0) }

        let expectation = self.expectation(description: "Receipt positions are sent")

        var result: [ReceiptPosition]?
        sut.positionsDidUpdate
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        let updatedPosition = ReceiptPosition(
            id: positions[1].id,
            amount: 3,
            buyer: .person(firstPerson),
            owner: .person(secondPerson)
        )

        sut.update(updatedPosition)

        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(result, [updatedPosition, positions[0]])
    }

    func testRemovePosition_whenTwoPositionsPersisted_sendsPositionThroughPositionsDidUpdate() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .all),
            .init(amount: 2, buyer: .person(secondPerson), owner: .all)
        ]
        positions.forEach { sut.insert($0) }

        var result: [ReceiptPosition]?
        let expectation = self.expectation(description: "Receipt Positions are sent")
        sut.positionsDidUpdate
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        sut.remove(positions[0])

        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(result, [positions[1]])
    }

    func testRemovePosition_whenTwoIdenticalPositionsPersisted_sendsPositionThroughPositionsDidUpdate() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .all),
            .init(amount: 1, buyer: .person(firstPerson), owner: .all)
        ]
        positions.forEach { sut.insert($0) }

        var result: [ReceiptPosition]?
        let expectation = self.expectation(description: "Receipt Positions are sent")
        sut.positionsDidUpdate
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        sut.remove(positions[0])

        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(result, [positions[1]])
    }

    func testRemoveAllPositions_oneItemPersisted_deletesOneItem() {
        sut.insert(.init(amount: 1, buyer: .person(.empty), owner: .all))
        sut.removeAllPositions()
        XCTAssertEqual(sut.fetchAll(), [])
    }

    func testRemoveAllPositions_twoItemsPersisted_deletesTwoItems() {
        sut.insert(.init(amount: 1, buyer: .person(firstPerson), owner: .all))
        sut.insert(.init(amount: 2, buyer: .person(secondPerson), owner: .all))

        sut.removeAllPositions()

        XCTAssertEqual(sut.fetchAll(), [])
    }

    func testRemoveAllPositions_sendsEmptyArrayThroughPositionsDidUpdate() {
        var result: [ReceiptPosition]?
        let expectation = self.expectation(description: "Receipt Positions are sent")
        sut.positionsDidUpdate
            .sink {
                result = $0
                expectation.fulfill()
            }
            .store(in: &subscriptions)

        sut.removeAllPositions()

        wait(for: [expectation], timeout: 0.3)
        XCTAssertEqual(result, [])
    }

    func testFetchPositions_whenNoItems_returnsEmptyArray() {
        XCTAssertEqual(sut.fetchAll(), [])
    }

    func testFetchPositions_whenOneItemAdded_returnsOneItem() {
        let person: Person = .withName("My name")
        peopleService.updatePeople(.fromPerson(person))

        let position = ReceiptPosition(amount: 1, buyer: .person(person), owner: .all)
        sut.insert(position)

        XCTAssertEqual(sut.fetchAll(), [position])
    }

    func testFetchPositions_whenFourItemAdded_returnsFourItemsInGivenOrder() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .person(secondPerson)),
            .init(amount: 2, buyer: .person(secondPerson), owner: .person(firstPerson)),
            .init(amount: 3, buyer: .person(firstPerson), owner: .all),
            .init(amount: 4, buyer: .person(secondPerson), owner: .all)
        ]

        positions.forEach { sut.insert($0) }

        XCTAssertEqual(sut.fetchAll(), positions.reversed())
    }
}
