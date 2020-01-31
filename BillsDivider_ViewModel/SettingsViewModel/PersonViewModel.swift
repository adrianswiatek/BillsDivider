import BillsDivider_Model
import Combine
import SwiftUI

public final class PersonViewModel: ObservableObject {
    @Published public var name: String
    @Published public var color: Color
    @Published public var hasDetailsOpened: Bool

    @Published private var person: Person

    public var personHasChanged: AnyPublisher<Person, Never> {
        personHasChangedSubject.eraseToAnyPublisher()
    }

    public var placeHolder: String {
        person.state == .generated ? person.name : ""
    }

    private var subscriptions: [AnyCancellable]
    private let index: Int
    private let personHasChangedSubject: CurrentValueSubject<Person, Never>

    public init(person: Person, withIndex index: Int) {
        self.person = person
        self.name = person.state == .generated ? "" : person.name
        self.color = person.colors.background.asColor
        self.index = index
        self.hasDetailsOpened = false
        self.personHasChangedSubject = .init(person)
        self.subscriptions = []
        self.bind()
    }

    private func bind() {
        $name
            .debounce(for: .seconds(0.33), scheduler: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] in self?.updateName(to: $0) }
            .store(in: &subscriptions)

        $color
            .sink { [weak self] in self?.updateColor(to: $0) }
            .store(in: &subscriptions)
    }

    private func updateName(to name: String) {
        person = name.isEmpty
            ? person.withUpdated(name: "", andNumber: index + 1)
            : person.withUpdated(name: name)
        
        personHasChangedSubject.send(person)
    }

    private func updateColor(to color: Color) {
        person = person.withUpdatedColors(.fromColor(color.asBDColor))
        personHasChangedSubject.send(person)
    }
}

extension PersonViewModel: Identifiable {
    public var id: UUID {
        person.id
    }
}

extension PersonViewModel: Equatable {
    public static func ==(lhs: PersonViewModel, rhs: PersonViewModel) -> Bool {
        lhs.id == rhs.id
    }
}

extension PersonViewModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue)
    }
}
