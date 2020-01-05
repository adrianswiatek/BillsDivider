import Combine
import Foundation

final class InMemoryReceiptPositionService: ReceiptPositionService {
    private let positionsDidUpdateSubject: CurrentValueSubject<[ReceiptPosition], Never>
    var positionsDidUpdate: AnyPublisher<[ReceiptPosition], Never> {
        positionsDidUpdateSubject.eraseToAnyPublisher()
    }

    private var positions: [ReceiptPosition] {
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
    }

    func insert(_ position: ReceiptPosition) {
        positions.insert(position, at: 0)
    }

    func update(_ position: ReceiptPosition) {
        guard let positionsIndex = positions.firstIndex(where: { $0.id == position.id }) else {
            preconditionFailure("Can not find index of given position")
        }

        positions[positionsIndex] = position
    }

    func remove(_ position: ReceiptPosition) {
        assert(positions.contains(position), "Positions doesn't contain given position")
        positions.removeAll { $0.id == position.id }
    }

    func removeAllPositions() {
        positions.removeAll()
    }

    func fetchPositions() -> [ReceiptPosition] {
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

    private func updatedBuyer(_ buyer: Buyer, in people: [Person]) -> Buyer {
        guard
            case let .person(existingPerson) = buyer,
            let updatedPerson = people.first(where: { $0.id == existingPerson.id })
        else { return buyer }

        return .person(updatedPerson)
    }

    private func updatedOwner(_ owner: Owner, in people: [Person]) -> Owner {
        guard
            case let .person(existingPerson) = owner,
            let updatedPerson = people.first(where: { $0.id == existingPerson.id })
        else { return owner }

        return .person(updatedPerson)
    }
}
