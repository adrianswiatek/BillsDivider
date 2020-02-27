import Combine
import CoreData

public final class CoreDataPeopleService: PeopleService {
    public var peopleDidUpdate: AnyPublisher<People, Never> {
        peopleDidUpdateSubject.eraseToAnyPublisher()
    }

    public let maximumNumberOfPeople: Int
    public let minimumNumberOfPeople: Int

    private let context: NSManagedObjectContext
    private let peopleDidUpdateSubject: CurrentValueSubject<People, Never>

    public init(_ context: NSManagedObjectContext, maximumNumberOfPeople: Int) {
        self.context = context
        self.maximumNumberOfPeople = maximumNumberOfPeople
        self.minimumNumberOfPeople = 2
        self.peopleDidUpdateSubject = .init(.empty)
        self.peopleDidUpdateSubject.send(fetchPeople())
    }

    public func numberOfPeople() -> Int {
        (try? context.count(for: fetchRequest())) ?? 0
    }

    public func fetchPeople() -> People {
        .fromArray(fetchEntities().map { $0.asPerson() })
    }

    public func updatePeople(_ people: People) {
        removeAllPeople()

        people.enumerated()
            .map { $1.asPersonEntity(orderNumber: $0, context: context) }
            .forEach { context.insert($0) }

        save()

        peopleDidUpdateSubject.send(people)
    }

    public func updatePerson(_ person: Person) {
        let people = fetchPeople().updating(person)
        updatePeople(people)
    }

    private func fetchEntities() -> [PersonEntity] {
        let request = fetchRequest()
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

    private func fetchRequest() -> NSFetchRequest<PersonEntity> {
        PersonEntity.fetchRequest() as NSFetchRequest<PersonEntity>
    }
}
