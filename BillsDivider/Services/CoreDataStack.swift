import CoreData

class CoreDataStack {
    static let modelName: String = "BillsDivider"
    static var model: NSManagedObjectModel {
        guard
            let url = Bundle.main.url(forResource: Self.modelName, withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: url)
        else { preconditionFailure("Unable to load Core Data model.") }
        return model
    }

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Self.modelName, managedObjectModel: Self.model)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
