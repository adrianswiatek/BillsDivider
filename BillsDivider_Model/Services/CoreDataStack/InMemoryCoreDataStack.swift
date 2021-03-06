import CoreData

public final class InMemoryCoreDataStack: CoreDataStack {
    public lazy var persistentContainer: NSPersistentContainer = {
        let inMemoryPersistentStoreDescription = NSPersistentStoreDescription()
        inMemoryPersistentStoreDescription.type = NSInMemoryStoreType

        let container = NSPersistentContainer(name: Self.modelName, managedObjectModel: Self.model)
        container.persistentStoreDescriptions = [inMemoryPersistentStoreDescription]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    public init() {}
}
