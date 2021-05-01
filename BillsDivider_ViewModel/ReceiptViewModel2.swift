import BillsDivider_Model
import Combine
import Foundation
import SwiftUI

public final class ReceiptViewModel2: ObservableObject {
    @Published
    public private(set) var positions: [ReceiptPositionViewModel]

    @Published
    public private(set) var canShowMoreActions: Bool

    private let positionService: ReceiptPositionService
    private let peopleService: PeopleService
    private let numberFormatter: NumberFormatter

    private var people: People
    private var cancellables: Set<AnyCancellable>

    public init(
        _ receiptPositionService: ReceiptPositionService,
        _ peopleService: PeopleService,
        _ numberFormatter: NumberFormatter
    ) {
        self.positionService = receiptPositionService
        self.peopleService = peopleService
        self.numberFormatter = numberFormatter

        self.people = .empty
        self.canShowMoreActions = false
        self.positions = []
        self.cancellables = []

        self.bind()
    }

    public func fetchPositions() {
        setPositions(positionService.fetchAll())
    }

    public func removePosition(with id: UUID) {
        positionService.removeById(id)
    }

    public func removePosition(at index: Int) {
        positionService.removeById(positions[index].id)
    }

    public func removeAllPositions() {
        positionService.removeAllPositions()
    }

    private func bind() {
        positionService.positionsDidUpdate
            .sink { [weak self] in self?.setPositions($0) }
            .store(in: &cancellables)

        peopleService.peopleDidUpdate
            .sink { [weak self] in self?.people = $0 }
            .store(in: &cancellables)
    }

    private func setPositions(_ positions: [ReceiptPosition]) {
        self.positions = positions.map { .init($0, people, numberFormatter) }
        self.canShowMoreActions = !positions.isEmpty
    }
}
