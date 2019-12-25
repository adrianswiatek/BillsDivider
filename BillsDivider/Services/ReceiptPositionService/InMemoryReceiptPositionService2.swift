import Combine
import Foundation

final class InMemoryReceiptPositionService2: ReceiptPositionService2 {
    private let positionsDidUpdateSubject: CurrentValueSubject<[ReceiptPosition2], Never>
    var positionsDidUpdate: AnyPublisher<[ReceiptPosition2], Never> {
        positionsDidUpdateSubject.eraseToAnyPublisher()
    }

    private var positions: [ReceiptPosition2] {
        didSet {
            positionsDidUpdateSubject.send(positions)
        }
    }

    private var subscriptions: [AnyCancellable]

    init(peopleService: PeopleService) {
        positionsDidUpdateSubject = .init([])
        positions = []
        subscriptions = []
        subscribe(to: peopleService.peopleDidUpdate)

        addTestPositions(peopleService.fetchPeople())
    }

    private func addTestPositions(_ people: [Person]) {
        positions = [
            .init(amount: 2, buyer: .person(people[0]), owner: .person(people[1])),
            .init(amount: 2, buyer: .person(people[1]), owner: .all),
            .init(amount: 4, buyer: .person(people[0]), owner: .person(people[1]))
        ]
    }

    func insert(_ position: ReceiptPosition2) {
        positions.insert(position, at: 0)
    }

    func update(_ position: ReceiptPosition2) {
        guard let positionsIndex = positions.firstIndex(where: { $0.id == position.id }) else {
            preconditionFailure("Can not find index of given position")
        }

        positions[positionsIndex] = position
    }

    func remove(_ position: ReceiptPosition2) {
        assert(positions.contains(position), "Positions doesn't contain given position")
        positions.removeAll { $0.id == position.id }
    }

    func removeAllPositions() {
        positions.removeAll()
    }

    func fetchPositions() -> [ReceiptPosition2] {
        positions
    }

    private func subscribe(to peopleDidUpdate: AnyPublisher<[Person], Never>) {
        peopleDidUpdate
            .sink { [weak self] people in
                guard let self = self else { return }
                self.positions = self.positions.map { position in
                    .init(
                        amount: position.amount,
                        buyer: self.updatedBuyer(position.buyer, in: people),
                        owner: self.updatedOwner(position.owner, in: people)
                    )
                }
            }
            .store(in: &subscriptions)
    }

    private func updatedBuyer(_ buyer: Buyer2, in people: [Person]) -> Buyer2 {
        guard
            case let .person(existingPerson) = buyer,
            let updatedPerson = people.first(where: { $0.id == existingPerson.id })
        else { return buyer }

        return .person(updatedPerson)
    }

    private func updatedOwner(_ owner: Owner2, in people: [Person]) -> Owner2 {
        guard
            case let .person(existingPerson) = owner,
            let updatedPerson = people.first(where: { $0.id == existingPerson.id })
        else { return owner }

        return .person(updatedPerson)
    }
}
