@testable import BillsDivider
import CoreData
import XCTest

class CoreDataReceiptPositionServiceTests: XCTestCase {
    private var sut: CoreDataReceiptPositionService!
    private var context: NSManagedObjectContext!
    private var peopleService: PeopleService!

    override func setUp() {
        super.setUp()
        peopleService = PeopleServiceFake()
        context = InMemoryCoreDataStack().context
        sut = CoreDataReceiptPositionService(context: context, peopleService: peopleService)
    }

    override func tearDown() {
        sut = nil
        context = nil
        super.tearDown()
    }

    func testUpdatePositions_withPosition_saveMethodHasBeenCalled() {
        let position = ReceiptPosition(amount: 1, buyer: .person(.empty), owner: .all)
        let exp = expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: context,
            handler: { _ in true }
        )

        sut.update(position)

        wait(for: [exp], timeout: 0.2)
    }

    func testUpdatePositions_withPosition_oneItemHasBeenInserted() {
        var insertedItems: Set<ReceiptPositionEntity>?
        let position = ReceiptPosition(amount: 1, buyer: .person(.empty), owner: .all)
        let exp = expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: context,
            handler: {
                insertedItems = $0.userInfo?["inserted"] as? Set<ReceiptPositionEntity>
                return true
            }
        )

        sut.update(position)

        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(insertedItems?.count, 1)
        XCTAssertEqual(insertedItems?.first?.id, position.id)
    }

    func testSetPositions_withTwoPositions_twoItemsHasBeenInserted() {
        let person1: Person = .withGeneratedName(forNumber: 1)
        let person2: Person = .withGeneratedName(forNumber: 2)

        var insertedItems: Set<ReceiptPositionEntity>?
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(person1), owner: .all),
            .init(amount: 2, buyer: .person(person2), owner: .all)
        ]
        let expectation = self.expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: context,
            handler: {
                guard
                    let set = $0.userInfo?["inserted"] as? Set<ReceiptPositionEntity>,
                    set.count == 1,
                    let position = set.first
                else { return false }

                insertedItems?.insert(position)
                return true
            }
        )

        positions.forEach { sut.insert($0) }

        wait(for: [expectation], timeout: 0.2)

        XCTAssertEqual(insertedItems?.count, 2)
        XCTAssertNotNil(insertedItems?.first { $0.id == positions[0].id })
        XCTAssertNotNil(insertedItems?.first { $0.id == positions[1].id })
    }

    func testSetPositions_calledTwiceWithTwoPositions_twoItemsHasBeenInsertedAndTwoDeleted() {
        let firstPerson: Person = .withGeneratedName(forNumber: 1)
        let secondPerson: Person = .withGeneratedName(forNumber: 2)
        var insertedUuids: [UUID]?
        var deletedUuids: [UUID]?
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .person(secondPerson)),
            .init(amount: 2, buyer: .person(secondPerson), owner: .person(firstPerson)),
            .init(amount: 3, buyer: .person(firstPerson), owner: .all),
            .init(amount: 4, buyer: .person(secondPerson), owner: .all)
        ]

        sut.insert(positions[0])
        sut.insert(positions[1])

        let expectation = self.expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: context,
            handler: {
                if let insertedItems = $0.userInfo?["inserted"] as? Set<ReceiptPositionEntity> {
                    insertedUuids = insertedItems.compactMap { $0.id }
                }

                if let deletedItems = $0.userInfo?["deleted"] as? Set<ReceiptPositionEntity> {
                    deletedUuids = deletedItems.compactMap { $0.id }
                }

                return true
            }
        )

        sut.insert(positions[2])
        sut.insert(positions[3])

        wait(for: [expectation], timeout: 0.2)

        XCTAssertEqual(insertedUuids?.count, 2)
        XCTAssertNotNil(insertedUuids?.contains(positions[2].id))
        XCTAssertNotNil(insertedUuids?.contains(positions[3].id))

        XCTAssertEqual(deletedUuids?.count, 2)
        XCTAssertNotNil(deletedUuids?.contains(positions[0].id))
        XCTAssertNotNil(deletedUuids?.contains(positions[1].id))
    }

    func testSetPositions_calledTwiceWithTwoPositionsAndWithoutPositions_twoItemsHasBeenDeletedAndZeroInserted() {
        let firstPerson: Person = .withGeneratedName(forNumber: 1)
        let secondPerson: Person = .withGeneratedName(forNumber: 2)
        var insertedUuids: [UUID] = []
        var deletedUuids: [UUID] = []
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .person(secondPerson)),
            .init(amount: 2, buyer: .person(secondPerson), owner: .person(firstPerson))
        ]

        positions.forEach { sut.insert($0) }

        let exp = expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: context,
            handler: {
                let insertedItems = $0.userInfo?["inserted"] as? Set<ReceiptPositionEntity>
                insertedUuids.append(contentsOf: insertedItems?.compactMap { $0.id } ?? [])

                let deletedItems = $0.userInfo?["deleted"] as? Set<ReceiptPositionEntity>
                deletedUuids.append(contentsOf: deletedItems?.compactMap { $0.id } ?? [])

                return true
            }
        )

        positions.forEach { sut.remove($0) }

        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(insertedUuids.count, 0)
        XCTAssertEqual(deletedUuids.count, 2)
        XCTAssertNotNil(deletedUuids.contains(positions[0].id))
        XCTAssertNotNil(deletedUuids.contains(positions[1].id))
    }

    func testFetchPositions_whenNoItems_returnsEmptyArray() {
        XCTAssertEqual(sut.fetchPositions(), [])
    }

    func testFetchPositions_whenOneItemAdded_returnsOneItem() {
        let position = ReceiptPosition(amount: 1, buyer: .person(.withGeneratedName(forNumber: 1)), owner: .all)
        sut.insert(position)

        let result = sut.fetchPositions()

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0], position)
    }

    func testFetchPositions_whenFourItemAdded_returnsFourItemsInGivenOrder() {
        let firstPerson: Person = .withGeneratedName(forNumber: 1)
        let secondPerson: Person = .withGeneratedName(forNumber: 2)

        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .person(secondPerson)),
            .init(amount: 2, buyer: .person(secondPerson), owner: .person(firstPerson)),
            .init(amount: 3, buyer: .person(firstPerson), owner: .all),
            .init(amount: 4, buyer: .person(secondPerson), owner: .all)
        ]

        positions.forEach { sut.insert($0) }

        let result = sut.fetchPositions()

        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result[0], positions[0])
        XCTAssertEqual(result[1], positions[1])
        XCTAssertEqual(result[2], positions[2])
        XCTAssertEqual(result[3], positions[3])
    }
}
