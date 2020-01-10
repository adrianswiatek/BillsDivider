import CoreData

public struct PeopleServiceFactory {
    public static func create(_ context: NSManagedObjectContext) -> PeopleService {
        let peopleService = CoreDataPeopleService(context, maximumNumberOfPeople: 2)
        updateInitialPeople(peopleService)
        return peopleService
    }

    private static func updateInitialPeople(_ peopleService: PeopleService) {
        let numberOfPeople = peopleService.numberOfPeople()
        let minimumNumberOfPeople = 2

        let initialPeople: People = (numberOfPeople ..< minimumNumberOfPeople)
            .map { .withGeneratedName(forNumber: $0 + 1) }
            .asPeople

        if initialPeople.any {
            peopleService.updatePeople(initialPeople)
        }
    }
}
