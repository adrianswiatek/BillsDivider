@testable import BillsDivider
import CoreData
import XCTest

class CoreDataReceiptPositionServiceTests: XCTestCase {
    private var sut: CoreDataReceiptPositionService!
    private var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        context = InMemoryCoreDataStack().context
        sut = CoreDataReceiptPositionService(context: context, mapper: .init())
    }

    override func tearDown() {
        sut = nil
        context = nil
        super.tearDown()
    }

    func testSetPositions_withOnePosition_saveMethodHasBeenCalled() {
        let positions: [ReceiptPosition] = [.init(amount: 1, buyer: .me, owner: .notMe)]
        let exp = expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: context,
            handler: { _ in true }
        )

        sut.set(positions)

        wait(for: [exp], timeout: 0.2)
    }

    func testSetPositions_withoutAnyPosition_savemethodHasNotBeenCalled() {
        let positions: [ReceiptPosition] = []
        let exp = expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: context,
            handler: { _ in true }
        )
        exp.isInverted = true

        sut.set(positions)

        wait(for: [exp], timeout: 0.2)
    }

    func testSetPositions_withOnePosition_oneItemHasBeenInserted() {
        var insertedItems: Set<ReceiptPositionEntity>?
        let positions: [ReceiptPosition] = [.init(amount: 1, buyer: .me, owner: .notMe)]
        let exp = expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: context,
            handler: {
                insertedItems = $0.userInfo?["inserted"] as? Set<ReceiptPositionEntity>
                return true
            }
        )

        sut.set(positions)

        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(insertedItems?.count, 1)
        XCTAssertEqual(insertedItems?.first?.id, positions[0].id)
    }

    func testSetPositions_withTwoPositions_twoItemsHasBeenInserted() {
        var insertedItems: Set<ReceiptPositionEntity>?
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .me, owner: .notMe),
            .init(amount: 2, buyer: .notMe, owner: .me)
        ]
        let exp = expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: context,
            handler: {
                insertedItems = $0.userInfo?["inserted"] as? Set<ReceiptPositionEntity>
                return true
            }
        )

        sut.set(positions)

        wait(for: [exp], timeout: 0.2)

        XCTAssertEqual(insertedItems?.count, 2)
        XCTAssertNotNil(insertedItems?.first { $0.id == positions[0].id })
        XCTAssertNotNil(insertedItems?.first { $0.id == positions[1].id })
    }

    func testSetPositions_calledTwiceWithTwoPositions_twoItemsHasBeenInsertedAndTwoDeleted() {
        var insertedUuids: [UUID]?
        var deletedUuids: [UUID]?
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .me, owner: .notMe),
            .init(amount: 2, buyer: .me, owner: .notMe),
            .init(amount: 3, buyer: .notMe, owner: .all),
            .init(amount: 4, buyer: .notMe, owner: .all)
        ]

        sut.set(Array(positions[0...1]))

        let exp = expectation(
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

        sut.set(Array(positions[2...3]))

        wait(for: [exp], timeout: 0.2)

        XCTAssertEqual(insertedUuids?.count, 2)
        XCTAssertNotNil(insertedUuids?.contains(positions[2].id))
        XCTAssertNotNil(insertedUuids?.contains(positions[3].id))

        XCTAssertEqual(deletedUuids?.count, 2)
        XCTAssertNotNil(deletedUuids?.contains(positions[0].id))
        XCTAssertNotNil(deletedUuids?.contains(positions[1].id))
    }

    func testSetPositions_calledTwiceWithTwoPositionsAndWithoutPositions_twoItemsHasBeenDeletedAndZeroInserted() {
        var insertedUuids: [UUID]?
        var deletedUuids: [UUID]?
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .me, owner: .notMe),
            .init(amount: 2, buyer: .me, owner: .notMe)
        ]

        sut.set(positions)

        let exp = expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: context,
            handler: {
                let insertedItems = $0.userInfo?["inserted"] as? Set<ReceiptPositionEntity>
                insertedUuids = insertedItems?.compactMap { $0.id }

                let deletedItems = $0.userInfo?["deleted"] as? Set<ReceiptPositionEntity>
                deletedUuids = deletedItems?.compactMap { $0.id }

                return true
            }
        )

        sut.set([])

        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(insertedUuids?.count, 0)
        XCTAssertEqual(deletedUuids?.count, 2)
        XCTAssertNotNil(deletedUuids?.contains(positions[0].id))
        XCTAssertNotNil(deletedUuids?.contains(positions[1].id))
    }

    func testFetchPositions_whenNoItems_returnsEmptyArray() {
        XCTAssertEqual(sut.fetchPositions(), [])
    }

    func testFetchPositions_whenOneItemAdded_returnsOneItem() {
        let positions: [ReceiptPosition] = [.init(amount: 1, buyer: .me, owner: .notMe)]
        sut.set(positions)

        let result = sut.fetchPositions()

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0], positions[0])
    }

    func testFetchPositions_whenFourItemAdded_returnsFourItemsInGivenOrder() {
        let positions: [ReceiptPosition] = [
            .init(amount: 1, buyer: .me, owner: .notMe),
            .init(amount: 2, buyer: .notMe, owner: .me),
            .init(amount: 3, buyer: .me, owner: .all),
            .init(amount: 4, buyer: .notMe, owner: .all)
        ]
        sut.set(positions)

        let result = sut.fetchPositions()

        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result[0], positions[0])
        XCTAssertEqual(result[1], positions[1])
        XCTAssertEqual(result[2], positions[2])
        XCTAssertEqual(result[3], positions[3])
    }
}
