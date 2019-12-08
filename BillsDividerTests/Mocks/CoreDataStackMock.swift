@testable import BillsDivider
import CoreData

class CoreDataStackMock: CoreDataStack {
    override init() {
        super.init()

        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        let persistentContainer = NSPersistentContainer(
            name: CoreDataStack.modelName,
            managedObjectModel: CoreDataStack.model
        )
        persistentContainer.persistentStoreDescriptions = [persistentStoreDescription]
        persistentContainer.loadPersistentStores { _, _ in }

        self.persistentContainer = persistentContainer
    }
}
