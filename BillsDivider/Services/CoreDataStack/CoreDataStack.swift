import CoreData

protocol CoreDataStack {
    var context: NSManagedObjectContext { get }
    var persistentContainer: NSPersistentContainer { get }
}

extension CoreDataStack {
    static var modelName: String {
        "BillsDivider"
    }
    
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
}
