import Combine
import Foundation

public final class InMemoryReceiptPositionService: ReceiptPositionService {
    private let positionsDidUpdateSubject: CurrentValueSubject<[ReceiptPosition], Never>
    public var positionsDidUpdate: AnyPublisher<[ReceiptPosition], Never> {
        positionsDidUpdateSubject.eraseToAnyPublisher()
    }

    private var positions: [ReceiptPosition] {
        didSet {
            positionsDidUpdateSubject.send(positions)
        }
    }

    private var subscriptions: [AnyCancellable]

    public init(peopleService: PeopleService) {
        positionsDidUpdateSubject = .init([])
        positions = []
        subscriptions = []
        subscribe(to: peopleService.peopleDidUpdate)
    }

    public func insert(_ position: ReceiptPosition) {
        positions.insert(position, at: 0)
    }

    public func update(_ position: ReceiptPosition) {
        guard let positionsIndex = positions.firstIndex(where: { $0.id == position.id }) else {
            preconditionFailure("Can not find index of given position")
        }

        positions[positionsIndex] = position
    }

    public func remove(_ position: ReceiptPosition) {
        assert(positions.contains(position), "Positions doesn't contain given position")
        positions.removeAll { $0.id == position.id }
    }

    public func removeById(_ id: UUID) {
        assert(positions.contains { $0.id == id }, "Positions doesn't contain position with given id")
        positions.removeAll { $0.id == id }
    }

    public func removeAllPositions() {
        positions.removeAll()
    }

    public func fetchAll() -> [ReceiptPosition] {
        positions
    }

    public func findById(_ id: UUID) -> ReceiptPosition? {
        positions.first { $0.id == id }
    }

    private func subscribe(to peopleDidUpdate: AnyPublisher<People, Never>) {
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

    private func updatedBuyer(_ buyer: Buyer, in people: People) -> Buyer {
        guard
            case let .person(existingPerson) = buyer,
            let updatedPerson = people.findBy(id: existingPerson.id)
        else { return buyer }

        return .person(updatedPerson)
    }

    private func updatedOwner(_ owner: Owner, in people: People) -> Owner {
        guard
            case let .person(existingPerson) = owner,
            let updatedPerson = people.findBy(id: existingPerson.id)
        else { return owner }

        return .person(updatedPerson)
    }
}
