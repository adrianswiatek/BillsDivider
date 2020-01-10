import BillsDivider_Model
import Combine
import Foundation
import SwiftUI

public class ReceiptViewModel: ObservableObject {
    @Published public var positions: [ReceiptPosition]

    public var ellipsisModeDisabled: Bool {
        positions.isEmpty
    }

    private let receiptPositionService: ReceiptPositionService
    private let numberFormatter: NumberFormatter

    private var people: People

    private var externalSubscriptions: [AnyCancellable]
    private var internalSubscriptions: [AnyCancellable]

    public init(
        _ receiptPositionService: ReceiptPositionService,
        _ peopleService: PeopleService,
        _ numberFormatter: NumberFormatter
    ) {
        self.receiptPositionService = receiptPositionService
        self.numberFormatter = numberFormatter
        self.people = .empty
        self.positions = []
        self.externalSubscriptions = []
        self.internalSubscriptions = []

        self.subscribe(to: receiptPositionService.positionsDidUpdate)
        self.subscribe(to: peopleService.peopleDidUpdate)
    }

    public func subscribe(
        addingPublisher: AnyPublisher<ReceiptPosition, Never>,
        editingPublisher: AnyPublisher<ReceiptPosition, Never>
    ) {
        externalSubscriptions.removeAll()

        addingPublisher
            .sink { [weak self] in self?.receiptPositionService.insert($0) }
            .store(in: &externalSubscriptions)

        editingPublisher
            .sink { [weak self] in self?.receiptPositionService.update($0) }
            .store(in: &externalSubscriptions)
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
        buyer.asPerson == people.first ? .green : .blue
    }

    public func colorFor(_ owner: Owner) -> Color {
        if owner == .all {
            return .purple
        }

        return owner.asPerson == people.first ? .green : .blue
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
}
