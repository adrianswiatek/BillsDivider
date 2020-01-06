@testable import BillsDivider_Model
import CoreData
import XCTest

class ReceiptPositionPlusCoreDataTests: XCTestCase {
    private var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        context = InMemoryCoreDataStack().context
    }

    override func tearDown() {
        context = nil
        super.tearDown()
    }

    private func receiptPositionEntity(
        _ positionId: UUID,
        _ amount: Decimal,
        _ buyerId: UUID,
        _ ownerId: UUID? = nil
    ) -> ReceiptPositionEntity {
        let entity = ReceiptPositionEntity(context: context)
        entity.id = positionId
        entity.amount = 1.25
        entity.buyerId = buyerId
        entity.ownerId = ownerId
        return entity
    }

    func testAsReceiptPositionEntity_returnsReceiptPositionEntityWithGivenOrderNumber() {
        let uuid = UUID()
        let buyer: Buyer = .person(.withGeneratedName(forNumber: 1))
        let owner: Owner = .person(.withGeneratedName(forNumber: 2))
        let receiptPosition = ReceiptPosition(id: uuid, amount: 1.25, buyer: buyer, owner: owner)

        let receiptPositionEntity =
            receiptPosition.asReceiptPositionEntity(orderNumber: 10, context: context)

        XCTAssertEqual(receiptPositionEntity.id, uuid)
        XCTAssertEqual(receiptPositionEntity.amount, 1.25)
        XCTAssertEqual(receiptPositionEntity.buyerId, buyer.asPerson.id)
        XCTAssertEqual(receiptPositionEntity.ownerId, owner.asPerson!.id)
        XCTAssertEqual(receiptPositionEntity.orderNumber, 10)
    }

    func testAsReceiptPosition_withOwner_returnsReceiptPosition() {
        let positionId = UUID()
        let buyerId = UUID()
        let ownerId = UUID()
        let receiptPositionEntity = self.receiptPositionEntity(positionId, 1.25, buyerId, ownerId)

        let receiptPosition = receiptPositionEntity.asReceiptPosition(people: [
            Person(id: buyerId, name: "Buyer", state: .default),
            Person(id: ownerId, name: "Owner", state: .default)
        ])

        XCTAssertEqual(receiptPosition?.id, positionId)
        XCTAssertEqual(receiptPosition?.amount, 1.25)
        XCTAssertEqual(receiptPosition?.buyer.asPerson.id, buyerId)
        XCTAssertEqual(receiptPosition?.owner.asPerson?.id, ownerId)
    }

    func testAsReceiptPosition_withoutOwner_returnsReceiptPositionWithOwnerSetToAll() {
        let positionId = UUID()
        let buyerId = UUID()
        let receiptPositionEntity = self.receiptPositionEntity(positionId, 1.25, buyerId)

        let receiptPosition = receiptPositionEntity.asReceiptPosition(people: [
            Person(id: buyerId, name: "Buyer", state: .default)
        ])

        XCTAssertEqual(receiptPosition?.id, positionId)
        XCTAssertEqual(receiptPosition?.amount, 1.25)
        XCTAssertEqual(receiptPosition?.buyer.asPerson.id, buyerId)
        XCTAssertEqual(receiptPosition?.owner, .all)
    }
}
