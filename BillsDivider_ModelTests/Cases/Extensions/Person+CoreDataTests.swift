@testable import BillsDivider_Model
import CoreData
import XCTest

class PersonPlusCoreDataTests: XCTestCase {
    private var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        context = InMemoryCoreDataStack().context
    }

    override func tearDown() {
        context = nil
        super.tearDown()
    }

    func testAsPersonEntity_returnsPersonEntityWithGivenOrderNumber() {
        let uuid = UUID()
        let person = Person(id: uuid, name: "My name", state: .default)

        let personEntity = person.asPersonEntity(orderNumber: 10, context: context)

        XCTAssertEqual(personEntity.id, uuid)
        XCTAssertEqual(personEntity.name, "My name")
        XCTAssertEqual(personEntity.state, Person.State.default.rawValue)
        XCTAssertEqual(personEntity.orderNumber, 10)
    }

    func testAsPerson_returnsPerson() {
        let uuid = UUID()
        let personEntity = PersonEntity(context: context)
        personEntity.id = uuid
        personEntity.name = "My name"
        personEntity.state = Person.State.default.rawValue

        let person = personEntity.asPerson()

        XCTAssertEqual(person.id, uuid)
        XCTAssertEqual(person.name, "My name")
        XCTAssertEqual(person.state, .default)
    }
}
