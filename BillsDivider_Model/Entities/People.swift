public struct People {
    private let people: [Person]

    public static var empty: People {
        People(people: [])
    }

    public static func fromArray(_ people: [Person]) -> People {
        People(people: people)
    }

    public static func fromPerson(_ person: Person) -> People {
        People(people: [person])
    }

    public subscript(index: Int) -> Person {
        assert(index < count, "There is no person under given index")
        return people[index]
    }

    public var asArray: [Person] {
        people
    }

    public var count: Int {
        people.count
    }

    public var any: Bool {
        !people.isEmpty
    }

    public var first: Person? {
        people.first
    }

    public func appending(_ person: Person) -> People {
        .fromArray(people + [person])
    }

    public func updating(_ person: Person) -> People {
        guard let index = people.firstIndex(where: { $0.id == person.id }) else {
            preconditionFailure("Given person does not exist on the list")
        }

        var mutablePeople = people
        mutablePeople[index] = person

        return .fromArray(mutablePeople)
    }

    public func findBy(id: UUID) -> Person? {
        people.first { $0.id == id }
    }

    public func filter(_ predicate: (Person) -> Bool) -> People {
        .fromArray(people.filter(predicate))
    }

    public func map<T>(_ transform: (Person) -> T) -> [T] {
        people.map(transform)
    }

    public func firstIndex(of person: Person) -> Int? {
        people.firstIndex(of: person)
    }

    public func enumerated() -> [(index: Int, person: Person)] {
        people.enumerated().map { (index: $0, person: $1) }
    }
}

extension People: Equatable {
    public static func ==(lhs: People, rhs: People) -> Bool {
        lhs.people == rhs.people
    }
}

extension Array where Element == Person {
    public var asPeople: People {
        .fromArray(self)
    }
}
