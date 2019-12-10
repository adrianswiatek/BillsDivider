@testable import BillsDivider
import CoreData
import XCTest

class ReceiptPositionMapperTests: XCTestCase {
    private var sut: ReceiptPositionMapper!
    private var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        sut = ReceiptPositionMapper()
        context = CoreDataStackFake().context
    }

    override func tearDown() {
        context = nil
        sut = ReceiptPositionMapper()
        super.tearDown()
    }

    private func createEntity() -> ReceiptPositionEntity {
        let entity = ReceiptPositionEntity(context: context)
        entity.id = UUID()
        entity.amount = NSDecimalNumber(decimal: 1)
        entity.buyer = String(describing: Buyer.me)
        entity.owner = String(describing: Owner.me)
        entity.orderNumber = 0
        return entity
    }

    func testMapPosition_withPosition_returnsEntity() {
        let position = ReceiptPosition(amount: 1, buyer: .me, owner: .notMe)

        let result: ReceiptPositionEntity = sut.map(position, 0, context)

        XCTAssertEqual(result.id, position.id)
        XCTAssertEqual(result.amount, NSDecimalNumber(decimal: position.amount))
        XCTAssertEqual(result.buyer, String(describing: position.buyer))
        XCTAssertEqual(result.owner, String(describing: position.owner))
        XCTAssertEqual(result.orderNumber, 0)
    }

    func testMapEntity_withValidEntity_returnsPosition() {
        let entity = createEntity()
        let result = sut.map(entity)

        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, entity.id)
        XCTAssertEqual(result?.amount, entity.amount!.decimalValue)
        XCTAssertEqual(result?.buyer, Buyer.from(string: entity.buyer!))
        XCTAssertEqual(result?.owner, Owner.from(string: entity.owner!))
    }

    func testMapEntity_whenEntityDoesNotHaveId_returnsNil() {
        let entity = createEntity()
        entity.id = nil

        let result = sut.map(entity)

        XCTAssertNil(result)
    }

    func testMapEntity_whenEntityDoesNotHaveAmount_returnsNil() {
        let entity = createEntity()
        entity.amount = nil

        let result = sut.map(entity)

        XCTAssertNil(result)
    }

    func testMapEntity_whenEntityDoesNotHaveBuyer_returnsNil() {
        let entity = createEntity()
        entity.buyer = nil

        let result = sut.map(entity)

        XCTAssertNil(result)
    }

    func testMapEntity_whenEntityDoesNotHaveOwner_returnsNil() {
        let entity = createEntity()
        entity.owner = nil

        let result = sut.map(entity)

        XCTAssertNil(result)
    }
}
