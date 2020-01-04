import Combine
import CoreData

final class CoreDataPeopleService: PeopleService {
    var peopleDidUpdate: AnyPublisher<[Person], Never> {
        peopleDidUpdateSubject.eraseToAnyPublisher()
    }

    let maximumNumberOfPeople: Int
    let minimumNumberOfPeople: Int

    private let context: NSManagedObjectContext
    private let peopleDidUpdateSubject: CurrentValueSubject<[Person], Never>

    init(context: NSManagedObjectContext, maximumNumberOfPeople: Int) {
        self.context = context
        self.maximumNumberOfPeople = maximumNumberOfPeople
        self.minimumNumberOfPeople = 2
        self.peopleDidUpdateSubject = .init([])
        self.peopleDidUpdateSubject.send(fetchPeople())
    }

    func numberOfPeople() -> Int {
        (try? context.count(for: PersonEntity.fetchRequest())) ?? 0
    }

    func fetchPeople() -> [Person] {
        fetchEntities().map { $0.asPerson() }
    }

    func updatePeople(_ people: [Person]) {
        removeAllPeople()

        people.enumerated()
            .map { $1.asPersonEntity(orderNumber: $0, context: context) }
            .forEach { context.insert($0) }

        save()

        peopleDidUpdateSubject.send(people)
    }

    private func fetchEntities() -> [PersonEntity] {
        let request: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
        request.sortDescriptors = [.init(keyPath: \PersonEntity.orderNumber, ascending: true)]

        return (try? context.fetch(request)) ?? []
    }

    private func removeAllPeople() {
        fetchEntities().forEach { context.delete($0) }
        save()
    }

    private func save() {
        guard context.hasChanges else { return }
        try? context.save()
    }
}
