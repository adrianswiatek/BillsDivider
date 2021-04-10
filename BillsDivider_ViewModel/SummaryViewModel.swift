import BillsDivider_Model
import Combine
import Foundation
import SwiftUI

public final class SummaryViewModel: ObservableObject {
    public var buyerAtTheTop: Buyer
    public var buyerAtTheBottom: Buyer

    public var formattedSum: String {
        numberFormatter.format(value: sumResult.amount)
    }

    public var formattedDebt: String {
        numberFormatter.format(value: divisionResult.debtAmount)
    }

    public var formattedDirection: String {
        switch divisionResult {
        case .noDebt:
            return "equal"
        case .debt(_, _, let amount) where amount <= 0:
            return "equal"
        case .debt(let lender, _, _) where lender == buyerAtTheTop:
            return "arrow.up"
        default:
            return "arrow.down"
        }
    }

    private let receiptPositionService: ReceiptPositionService
    private let divider: PositionsDivider
    private let numberFormatter: NumberFormatter

    private var divisionResult: DivisionResult
    private var sumResult: SumResult

    private var people: People
    private var cancellables: Set<AnyCancellable>

    public init(
        _ receiptPositionService: ReceiptPositionService,
        _ peopleService: PeopleService,
        _ divider: PositionsDivider,
        _ numberFormatter: NumberFormatter
    ) {
        self.receiptPositionService = receiptPositionService
        self.divider = divider
        self.numberFormatter = numberFormatter

        self.people = .empty
        self.cancellables = []

        self.divisionResult = .noDebt
        self.sumResult = .zero
        self.buyerAtTheTop = .person(.empty)
        self.buyerAtTheBottom = .person(.empty)

        self.subscribe(to: receiptPositionService.positionsDidUpdate)
        self.subscribe(to: peopleService.peopleDidUpdate)
    }

    public func name(for buyer: Buyer) -> String {
        buyer.formatted
    }

    public func color(for buyer: Buyer) -> Color {
        buyer.asPerson.colors.background.asColor
    }

    private func subscribe(to positionsDidUpdate: AnyPublisher<[ReceiptPosition], Never>) {
        positionsDidUpdate
            .sink { [weak self] in
                guard let self = self else { return }
                self.divisionResult = self.divider.divide($0, between: self.people)
                self.sumResult = .from(values: $0.map { $0.amountWithDiscount })
                self.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    private func subscribe(to peopleDidUpdate: AnyPublisher<People, Never>) {
        peopleDidUpdate
            .sink { [weak self] in
                precondition($0.count >= 2, "There must be at least 2 people.")

                self?.people = $0
                self?.buyerAtTheTop = .person($0[0])
                self?.buyerAtTheBottom = .person($0[1])
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
