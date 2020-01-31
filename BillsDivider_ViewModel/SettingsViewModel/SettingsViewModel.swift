import BillsDivider_Model
import Combine
import Foundation
import SwiftUI

public final class SettingsViewModel: ObservableObject {
    @Published public var peopleViewModel: [PersonViewModel]

    public var formattedNumberOfPeople: String {
        peopleViewModel.count.description
    }

    public let colors: [Color]

    private let peopleService: PeopleService
    private var subscriptions: [AnyCancellable]

    public init(_ peopleService: PeopleService, _ availableColors: [BDColor]) {
        self.peopleService = peopleService
        self.colors = availableColors.map { $0.asColor }
        self.subscriptions = []

        self.peopleViewModel = peopleService.fetchPeople().enumerated().map {
            PersonViewModel(person: $1, withIndex: $0)
        }

        self.bind()
    }

    public func canAddPerson() -> Bool {
        peopleService.canAddPerson()
    }

    public func canRemovePerson() -> Bool {
        peopleService.canRemovePerson()
    }

    public func addPerson() {
        let nextPersonsIndex = peopleViewModel.count + 1
        let person: Person = .withGeneratedName(forNumber: nextPersonsIndex)
        peopleViewModel.append(.init(person: person, withIndex: nextPersonsIndex))
    }

    public func index(of personViewModel: PersonViewModel) -> Int {
        guard let index = peopleViewModel.firstIndex(of: personViewModel) else {
            preconditionFailure("Given person does not exist in people list")
        }
        return index
    }

    public func reset() {
        peopleViewModel.forEach { $0.hasDetailsOpened = false }
    }

    private func bind() {
        peopleViewModel.forEach {
            $0.objectWillChange
                .sink { [weak self] in self?.objectWillChange.send() }
                .store(in: &subscriptions)

            $0.personHasChanged
                .sink { [weak self] in self?.peopleService.updatePerson($0) }
                .store(in: &subscriptions)
        }
    }
}
