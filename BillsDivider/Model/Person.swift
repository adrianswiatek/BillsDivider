import Foundation

struct Person: Equatable {
    let id: UUID
    let name: String

    func withUpdated(name: String) -> Person {
        .init(id: id, name: name)
    }
}

extension Person {
    init(name: String = "") {
        self.name = name
        self.id = UUID()
    }
}
