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

    func testInsertPositions_withPosition_saveMethodHasBeenCalled() {
        let position = ReceiptPosition(amount: 1, buyer: .person(.empty), owner: .all)
        let exp = expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: context,
            handler: { _ in true }
        )

        sut.insert(position)

        wait(for: [exp], timeout: 0.2)
    }

    func testInsertPositions_withPosition_oneItemHasBeenInserted() {
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

        sut.insert(position)

        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(insertedItems?.count, 1)
        XCTAssertEqual(insertedItems?.first?.id, position.id)
    }

    func testRemovePosition_oneItemHasBeenDeletedAndZeroInserted() {
        let firstPerson: Person = .withGeneratedName(forNumber: 1)
        let secondPerson: Person = .withGeneratedName(forNumber: 2)
        var insertedUuids: [UUID] = []
        var deletedUuids: [UUID] = []
        let position = ReceiptPosition(amount: 1, buyer: .person(firstPerson), owner: .person(secondPerson))

        sut.insert(position)

        let expectation = self.expectation(
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

        sut.remove(position)

        wait(for: [expectation], timeout: 0.2)
        XCTAssertEqual(deletedUuids.count, 1)
        XCTAssertEqual(insertedUuids.count, 0)
        XCTAssertNotNil(deletedUuids.contains(position.id))
    }

    func testFetchPositions_whenNoItems_returnsEmptyArray() {
        XCTAssertEqual(sut.fetchPositions(), [])
    }

    func testFetchPositions_whenOneItemAdded_returnsOneItem() {
        let person: Person = .withName("My name")
        peopleService.updatePeople([person])

        let position = ReceiptPosition(amount: 1, buyer: .person(person), owner: .all)
        sut.insert(position)

        let result = sut.fetchPositions()

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0], position)
    }

    func testFetchPositions_whenFourItemAdded_returnsFourItemsInGivenOrder() {
        let firstPerson: Person = .withGeneratedName(forNumber: 1)
        let secondPerson: Person = .withGeneratedName(forNumber: 2)
        peopleService.updatePeople([firstPerson, secondPerson])

        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .person(firstPerson), owner: .person(secondPerson)),
            .init(amount: 2, buyer: .person(secondPerson), owner: .person(firstPerson)),
            .init(amount: 3, buyer: .person(firstPerson), owner: .all),
            .init(amount: 4, buyer: .person(secondPerson), owner: .all)
        ]

        positions.forEach { sut.insert($0) }

        let result = sut.fetchPositions()

        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result[0], positions[3])
        XCTAssertEqual(result[1], positions[2])
        XCTAssertEqual(result[2], positions[1])
        XCTAssertEqual(result[3], positions[0])
    }
}
