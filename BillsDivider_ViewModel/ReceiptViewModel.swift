import BillsDivider_Model
import Combine
import Foundation
import SwiftUI

public class ReceiptViewModel: ObservableObject {
    @Published public var positions: [ReceiptPosition]
    @Published public var itemAdded: Bool

    public var ellipsisModeDisabled: Bool {
        positions.isEmpty
    }

    private let receiptPositionService: ReceiptPositionService
    private let numberFormatter: NumberFormatter

    private var people: People

    private var positionsSubscriptions: [AnyCancellable]
    private var reductionsSubscriptions: [AnyCancellable]
    private var internalSubscriptions: [AnyCancellable]

    public init(
        _ receiptPositionService: ReceiptPositionService,
        _ peopleService: PeopleService,
        _ numberFormatter: NumberFormatter
    ) {
        self.receiptPositionService = receiptPositionService
        self.numberFormatter = numberFormatter
        self.itemAdded = false
        self.people = .empty
        self.positions = []
        self.positionsSubscriptions = []
        self.reductionsSubscriptions = []
        self.internalSubscriptions = []

        self.subscribe(to: receiptPositionService.positionsDidUpdate)
        self.subscribe(to: peopleService.peopleDidUpdate)
        self.subscribe(to: $itemAdded.eraseToAnyPublisher())
    }

    public func subscribe(
        addingPublisher: AnyPublisher<ReceiptPosition, Never>,
        editingPublisher: AnyPublisher<ReceiptPosition, Never>
    ) {
        positionsSubscriptions.removeAll()

        addingPublisher
            .sink { [weak self] in
                self?.receiptPositionService.insert($0)
                self?.itemAdded = true
            }
            .store(in: &positionsSubscriptions)

        editingPublisher
            .sink { [weak self] in
                self?.receiptPositionService.update($0)
            }
            .store(in: &positionsSubscriptions)
    }

    public func subscribe(reducingPublisher: AnyPublisher<ReceiptPosition, Never>) {
        reductionsSubscriptions.removeAll()

        reducingPublisher
            .sink { [weak self] in
                self?.receiptPositionService.insert($0)
                self?.itemAdded = true
            }
            .store(in: &positionsSubscriptions)
    }

    public func removePosition(at index: Int) {
        precondition(index >= 0 && index < positions.count, "Invalid index")
        removePosition(positions[index])
    }

    public func removePosition(_ position: ReceiptPosition) {
        receiptPositionService.remove(position)
    }

    public func removeAllPositions() {
        receiptPositionService.removeAllPositions()
    }

    public func formatNumber(value: Decimal) -> String {
        numberFormatter.format(value: value)
    }

    public func colorFor(_ buyer: Buyer) -> Color {
        buyer.asPerson.colors.background.asColor
    }

    public func colorFor(_ owner: Owner) -> Color {
        if owner == .all {
            return .gray
        }

        guard let person = owner.asPerson else {
            preconditionFailure("Owner is not a person")
        }

        return person.colors.background.asColor
    }

    private func subscribe(to receiptPositionDidUpdate: AnyPublisher<[ReceiptPosition], Never>) {
        receiptPositionDidUpdate
            .sink { [weak self] in self?.positions = $0 }
            .store(in: &internalSubscriptions)
    }

    private func subscribe(to peopleDidUpdate: AnyPublisher<People, Never>) {
        peopleDidUpdate
            .sink { [weak self] in self?.people = $0 }
            .store(in: &internalSubscriptions)
    }

    private func subscribe(to itemAdded: AnyPublisher<Bool, Never>) {
        itemAdded
            .delay(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self, self.itemAdded else { return }
                self.itemAdded = false
            }
            .store(in: &internalSubscriptions)
    }
}
