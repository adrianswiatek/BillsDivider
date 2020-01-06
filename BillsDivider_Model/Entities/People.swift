public struct People {
    private let people: [Person]

    public static var empty: People {
        People(people: [])
    }

    public static func from(_ people: [Person]) -> People {
        People(people: people)
    }

    public static func from(_ people: Person...) -> People {
        People(people: people)
    }

    public subscript(index: Int) -> Person {
        people[index]
    }

    public func asArray() -> [Person] {
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
        .from(people + [person])
    }

    public func findBy(id: UUID) -> Person? {
        people.first { $0.id == id }
    }

    public func filter(_ predicate: (Person) -> Bool) -> People {
        .from(people.filter(predicate))
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
    public func asPeople() -> People {
        .from(self)
    }
}
