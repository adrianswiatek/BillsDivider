import CoreData

public final class SqliteCoreDataStack: CoreDataStack {
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Self.modelName, managedObjectModel: Self.model)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    public init() {}
}
